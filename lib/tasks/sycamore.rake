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
      print "."
    end
  end
  
  desc "Import all parents from Sycamore"
  task :import_parents => :environment do
    family_ids = SISRecord.distinct.pluck(:family_id)
    
    family_ids.each do |family_id|
      print "F"
      cf = Sycamore::ContactsFetcher.call(family_id: family_id)
      print "X" && next unless cf.success?
    
      contacts = cf.payload
      contacts.each do |contact|
        sr = SISRecord.find_or_initialize_by(record_type: "contact", sis_id: contact["ID"])
        sr.family_id = family_id
        if sr.new_record?
          sr.person = Person.new(official_family_name: contact["LastName"], official_given_name: contact["FirstName"], personal_email: contact["Email"])
          sr.person.save
          sr.save
          print "c" && next # create
        end
        
        if sr.changed?
          sr.save
          print "u" && next # update
        end
        
        print "." # no change
      end
    end
  end
  
  desc "Update students"
  task :update_students => :environment do
    SISRecord.student.each do |sr|
      print "."
      sf = Sycamore::StudentFetcher.call(sis_id: sr.sis_id)
      next unless sf.success?
    
      student = sf.payload
      
      sr.person.school_email = student["Email"]
      sr.person.date_of_birth = student["DOB"]
      sr.person.gender = student["Gender"]
      sr.person.preferred_given_name = student["NickName"] if student["NickName"].present?
      if sr.person.changed?
        sr.person.save
        print "p" #person
      end
      
      sr.student_grade = student["Grade"]
      sr.campus = student["Location"]
      if sr.changed?
        sr.save
        print "s" #sis
      end
    end
  end
  
  desc "Link families (based on existing family_id)"
  task :link_families => :environment do
    SISRecord.student.each do |student|
      puts student.person.display_name
      parents = SISRecord.contact.where(family_id: student.family_id)

      parents.each do |parent|
        print "\t#{parent.person.display_name}"
        puts " ✅" if FamilyRelationship.find_or_create_by(student: student.person, contact: parent.person)
      end
    end
  end
end
