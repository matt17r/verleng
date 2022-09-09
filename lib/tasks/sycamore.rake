namespace :sycamore do
  desc "Import all students from Sycamore"
  task :import_students => :environment do
    sf = Sycamore::StudentsFetcher.call
    
    return unless sf.success?
    
    students = sf.payload
    students.each do |student|
      p = Person.find_or_create_by!(official_given_name: student["FirstName"], official_family_name: student["LastName"]) #TODO update this naive creation strategy
      sr = p.sis_records.find_or_create_by!(record_type: "student", sis_id: student["ID"])
      sr.student_grade = student["Grade"]
      sr.code = student["StudentCode"]
      sr.family_id = student["FamilyID"]
      sr.save
    end
  end
end  
  desc "Import all parents from Sycamore"
  task :import_parents => :environment do
    family_ids = SISRecord.distinct.pluck(:family_id)
    
    family_ids.each do |family_id|
      cf = Sycamore::ContactsFetcher.call(family_id: family_id)
      next unless cf.success?
    
      contacts = cf.payload
      contacts.each do |contact|
        sr = SISRecord.find_or_initialize_by(record_type: "contact", sis_id: contact["ID"], family_id: contact["FamilyID"])
        if sr.new_record?
          sr.person = Person.new(official_family_name: contact["LastName"], official_given_name: contact["FirstName"], personal_email: contact["Email"])
        end
        sr.save
      end
    end
  end
end
