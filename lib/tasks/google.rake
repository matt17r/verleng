namespace :google do
  desc "Import groups from Google Directory for random user, demo task"
  task :import_groups => :environment do
    random_person = Person.find(Person.where.not(school_email: nil).ids.sample)
    ugf = Google::UserGroupsFetcher.call(email: random_person.school_email)
    abort(ugf.error) unless ugf.success?
    
    if !ugf.payload || ugf.payload.size == 0
      puts "No groups to import for #{random_person.school_email}"
      next
    end
    
    puts "Importing #{ugf.payload.size} groups for #{random_person.school_email}"
    ugf.payload.each do |g|
      puts "\t#{g[:name]} (#{g[:email]})"
      group = Group.find_or_create_by(dir_id: g[:id])
      group.update(name: g[:name], dir_name: g[:name], dir_email: g[:email], dir_description: g[:description], dir_aliases: g[:aliases] || [])
      
      DirectoryGroupMembership.find_or_create_by(group: group, person: random_person)
    end
  end
  
  desc "Import group members from Google Directory for random group, demo task"
  task :import_members => :environment do
    random_group = Group.find(Group.where.not(dir_email: nil).ids.sample)
    gmf = Google::GroupMembersFetcher.call(group_email_or_id: random_group.dir_email)
    abort(gmf.error) unless gmf.success?
    
    if !gmf.payload || gmf.payload.size == 0
      puts "No members to import for #{random_group.dir_email}"
      next
    end
    
    puts "Found #{gmf.payload.size} members of #{random_group.dir_email}"
    gmf.payload.each do |m|
      next unless m[:type] == "USER"
      
      person = Person.find_by(school_email: m[:email]) || Person.find_by(personal_email: m[:email])
      puts "\tSkipping #{m[:email]}" && next unless person
      
      puts "\t#{m[:email]} (#{m[:role]})"
      DirectoryGroupMembership.find_or_create_by(group: random_group, person: person)
    end
  end
end
