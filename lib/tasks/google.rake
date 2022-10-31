namespace :google do
  desc "Sync profile pictures for active users (import, update and delete)"
  task :sync_profile_images => :environment do
    errors = []
    users = GWD::User.active

    puts "Found #{users.count} users (e for error, - for removed, . for existing, + for new/updated):"
    users.each do |u|
      gupf = Google::UserPhotoFetcher.call(user_key: u.id)
      if !gupf.success? && gupf.error.message.include?(":code=>404")
        u.update!(image: "", image_etag: "")
        print "-"
        next
      end

      if !gupf.success?
        print "e"
        errors << u.email
        next
      end

      image_data = gupf.payload

      if u.image_etag == image_data[:etag]
        print "."
        next
      end

      u.update!(image: "data:#{image_data[:mimeType]};base64,#{image_data[:photoData]}", image_etag: image_data[:etag])
      print "+"
    end

    if errors.present?
      puts "\n#{errors.count} error(s)..."
      puts "\t#{errors.join("\n\t")}"
    end
  end

  desc "Sync GWD users (import, update and delete)"
  task :sync_users => :environment do
    start_time = Time.now()
    changes = []
    puts "Requesting users..."
    guf = Google::UsersFetcher.call
    abort(guf.error.to_s) unless guf.success?

    puts "Found #{guf.payload&.size || 0} users (. for existing, + for new/updated):"
    guf.payload.each do |u|
      user = GWD::User.find_or_initialize_by(id: u[:id])
      if user.etag && user.etag == u[:etag] && user.deleted_at == nil
        user.touch
        print "."
        next
      end

      user.attributes = {
        etag: u[:etag],
        email: u[:primaryEmail],
        given_name: u[:name][:givenName],
        family_name: u[:name][:familyName],
        full_name: u[:name][:fullName],
        suspended: u[:suspended],
        email_aliases: u[:aliases] || [],
        org_unit: u[:orgUnitPath],
        deleted_at: nil
      }
      if !user.changed?
        user.touch
        print "."
        next
      end
      user.save!
      changes.push({"email": u[:primaryEmail]}.merge(user.saved_changes).except("updated_at"))
      print "+"
    end
    puts "\n\nSummary of first 10 changes:\n#{changes.first(10).join("\n")}" if changes.present?

    stale_users = GWD::User.active.where("updated_at < ?", start_time)
    puts "\nFound #{stale_users.count} users to be deleted"
    abort("Aborting: Too many users to be deleted") if stale_users.count > 15
    stale_users.each do |u|
      puts "\tSoft deleting \"#{u.email}\""
      u.update(deleted_at: Time.now)
    end
  end

  desc "Sync GWD groups (import, update and delete)"
  task :sync_groups => :environment do
    start_time = Time.now()
    changes = []
    puts "Requesting groups..."
    ggf = Google::GroupsFetcher.call
    abort(ggf.error.to_s) unless ggf.success?

    puts "Found #{ggf.payload&.size || 0} groups (. for existing, + for new/updated):"
    ggf.payload.each do |g|
      group = GWD::Group.find_or_initialize_by(id: g[:id])
      if group.etag && group.etag == g[:etag] && group.deleted_at == nil
        group.touch
        print "."
        next
      end

      group.attributes = {
        etag: g[:etag],
        name: g[:name],
        email: g[:email],
        description: g[:description],
        aliases: g[:aliases] || [],
        deleted_at: nil
      }
      group.save!
      changes.push({"email": g[:email]}.merge(group.saved_changes).except("etag", "updated_at"))
      print "+"
    end
    puts "\n\nSummary of first 10 changes:" if changes.present?
    puts changes.first(10).join("\n")

    stale_groups = GWD::Group.active.where("updated_at < ?", start_time)
    puts "\nFound #{stale_groups.count} groups to be deleted"
    abort("Aborting: Too many groups to be deleted") if stale_groups.count > 5
    stale_groups.each do |g|
      puts "\tSoft deleting \"#{g.email}\""
      g.update(deleted_at: Time.now)
    end
  end

  desc "Sync members of active groups (import, update and delete)"
  task :sync_members, [:no_safety_check] => :environment do |task, args|
    args.with_defaults(no_safety_check: false)

    start_time = Time.now()
    changes = []
    skipped_groups = []

    GWD::Group.active.each do |group|
      puts "\nProcessing: #{group.email}"

      ggmf = Google::GroupMembersFetcher.call(group_key: group.id)
      abort(ggmf.error.to_s) unless ggmf.success?

      puts "Fetched #{ggmf.payload&.size || 0} current members. Comparing with #{group.memberships.count} stored members.\n\t. for existing\n\t+ for new/updated:"
      ggmf.payload.each do |m|
        # First try to find a matching user or group in our system (assumes sync_users and sync_groups have both been run recently)
        polymorphic_member = (m[:type].downcase == "user") ? GWD::User.find_by(id: m[:id]) : GWD::Group.find_by(id: m[:id])
        # If we couldn't find a user or group, try to create an EmailContact (will fail validation if it's not an external address)
        polymorphic_member = GWD::EmailContact.find_or_create_by(id: m[:id], email: m[:email]) unless polymorphic_member
        abort("Can't find #{m[:type]} #{m[:email]}") if !polymorphic_member

        gm = GWD::GroupMembership.find_or_create_by(group: group, member: polymorphic_member)
        gm.attributes = {
          email: m[:email],
          role: m[:role].downcase
        }
        if gm.changed?
          if !gm.valid?
            system(">&2 echo \"#{gm.email}:\t#{gm.errors}\"")
            print "!"
          else
            gm.save!
            print "+"
          end
        else
          gm.touch
          print "."
        end
      end

      stale_memberships = group.memberships.where("updated_at < ?", start_time)
      too_many_deletions = (stale_memberships.count > 5 && !args.no_safety_check)

      puts "\nFound #{stale_memberships.count} members to be deleted:"

      if too_many_deletions
        puts "\tSkipping, too many members to be deleted."
        skipped_groups << group
        next
      end

      stale_memberships.each do |member|
        puts "\tRemoving \"#{member.email}\""
        member.destroy
      end
    end

    if skipped_groups.count > 0
      puts "Skipped #{skipped_groups.count} with several members to be deleted. Run again with [no_safety_check: true] to process those groups too"
    end
  end
end
