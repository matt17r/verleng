namespace :google do
  desc "Import groups from Google Directory for random user, demo task"
  task :import_groups => :environment do
    random_person = Person.find(Person.where.not(school_email: nil).ids.sample)
    gg = Google::UserGroupsFetcher.call(email: random_person.school_email)
    abort(gg.error) unless gg.success?
    
    if !gg.payload || gg.payload.size == 0
      puts "No groups to import for #{random_person.school_email}"
      next
    end
    
    puts "Importing #{gg.payload.size} groups for #{random_person.school_email}"
    gg.payload.each do |g|
      puts "\t#{g[:name]} (#{g[:email]})"
      group = Group.find_or_create_by(dir_id: g[:id])
      group.update(name: g[:name], dir_name: g[:name], dir_email: g[:email], dir_description: g[:description], dir_aliases: g[:aliases] || [])
      
      DirectoryGroupMembership.find_or_create_by(group: group, person: random_person)
    end
  end
end
