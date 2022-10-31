namespace :sycamore do
  desc "Sync students with Sycamore"
  task :sync_students, [:full_sync, :no_safety_checks] => :environment do |task, args|
    args.with_defaults(full_sync: false, no_safety_checks: false)

    start_time = Time.now()
    changes = []
    errors = []
    puts "Requesting students..."
    sf = Sycamore::StudentsFetcher.call
    abort(sf.error.to_s) unless sf.success?

    puts "Found #{sf.payload.size} students (. for existing, + for new/updated):"
    sf.payload.each do |s|
      student = Sycamore::Student.find_or_initialize_by(id: s["ID"])
      student.attributes = {
        code: s["StudentCode"],
        given_name: s["FirstName"],
        family_name: s["LastName"],
        family_id: s["FamilyID"]
      }
      if args.full_sync
        single_fetcher = Sycamore::StudentFetcher.call(sis_id: student.id)
        if single_fetcher.success?
          student.attributes = { # each attribute will be nil if fetched value is blank
            preferred_name: single_fetcher.payload["NickName"].presence,
            birthday: single_fetcher.payload["DOB"].to_date,
            email: single_fetcher.payload["Email"].presence,
            gender: single_fetcher.payload["Gender"].presence,
            location: single_fetcher.payload["Location"].presence,
            grade: single_fetcher.payload["Grade"].presence,
            phone: single_fetcher.payload["Cell"].presence,
          }
        else
          errors << "Couldn't fetch details for #{student.id}: #{single_fetcher.error}"
        end
      end

      unless student.changed?
        student.touch
        print "."
        next
      end

      student.save!
      changes.push({"code": s[:StudentCode]}.merge(student.saved_changes).except("updated_at"))
      print "+"
    end

    puts "\n\nSummary of first 10 changes:\n#{changes.first(10).join("\n")}" if changes.present?

    stale_students = Sycamore::Student.active.where("updated_at < ?", start_time).order(:family_name, :given_name)
    too_many_deletions = (stale_students.count > 10 && !args.no_safety_check)

    puts "\nFound #{stale_students.count} students to be deleted:"

    if too_many_deletions
      puts "\tSkipping, too many students to be deleted. Run again with [no_safety_check: true] to delete missing students"
      next
    end

    stale_students.each do |student|
      puts "\tSoft deleting \"#{student.code} #{student.family_name} #{student.given_name}\""
      student.update(deleted_at: Time.now)
    end
  end

  desc "Sync all contacts with Sycamore"
  task :sync_contacts => :environment do
    start_time = Time.now()
    changes = []
    errors = []

    family_ids = Sycamore::Student.active.select(:family_id).distinct.pluck(:family_id)
    puts "Fetching contacts from #{family_ids.count} families... (F for family, . for existing contact, + for new/updated contact)"
    family_ids.each do |family_id|

      cf = Sycamore::ContactsFetcher.call(family_id: family_id)
      unless cf.success?
        errors << "Error fetching family #{family_id}: #{cf.error}"
        next
      end

      print "F"
      contacts = cf.payload
      contacts.each do |c|
        contact = Sycamore::Contact.find_or_initialize_by(id: c["ID"])
        contact.attributes = {
          family_id: family_id,
          given_name: c["FirstName"],
          family_name: c["LastName"],
          email: c["Email"],
          mobile_phone: c["CellPhone"],
          work_phone: c["WorkPhone"],
          home_phone: c["HomePhone"],
          family_role: c["Relation"],
          primary_parent: c["PrimaryParent"] == 1,
          authorised_pickup: c["Pickup"] == 1,
          emergency_contact: c["Emergency"] == 1,
        }

        unless contact.changed?
          contact.touch
          print "."
          next
        end

        contact.save!
        changes.push({"family_id": family_id}.merge(contact.saved_changes).except("updated_at"))
        print "+"
      end
    end

    puts "\n\nSummary of first 10 changes:\n#{changes.first(10).join("\n")}" if changes.present?

    stale_contacts = Sycamore::Contact.active.where("updated_at < ?", start_time).order(:family_name, :given_name)
    too_many_deletions = (stale_contacts.count > 10 && !args.no_safety_check)

    puts "\nFound #{stale_contacts.count} contacts to be deleted:"

    if too_many_deletions
      puts "\tSkipping, too many contacts to be deleted. Run again with [no_safety_check: true] to delete stale contacts"
      next
    end

    stale_contacts.each do |contact|
      puts "\tSoft deleting \"#{contact.code} #{contact.family_name} #{contact.given_name}\""
      contact.update(deleted_at: Time.now)
    end
  end
end
