namespace :google do
  desc "Import groups from Google Directory for random user, demo task"
  task :import_groups => :environment do
    random_person = Person.find(Person.where.not(school_email: nil).ids.sample)
    gg = Google::UserGroupsFetcher.call(email: random_person.school_email)
    return unless gg.success?
    
    puts "Creating #{gg.payload.size} groups for #{random_person.school_email}"
    gg.payload.each do |g|
      new_group = Group.find_or_create_by(name: g[:name], dir_id: g[:id], dir_name: g[:name], dir_email: g[:email], dir_description: g[:description], dir_aliases: g[:aliases] || [])
      
      new_group.members << random_person
    end
  end
end
