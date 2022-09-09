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