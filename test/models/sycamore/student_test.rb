require "test_helper"

class Sycamore::StudentTest < ActiveSupport::TestCase
  test "can create a valid student" do
    student = Sycamore::Student.new(id: "Sample ID", code: "Sample code")

    assert student.valid?, "Student with required fields is not valid"
  end
  
  test "Code is required" do
    student = sycamore_students(:valid_student)
    student.code = nil
  
    assert_not student.valid?, "Student is valid despite missing Code"
  end
  
  test "student code is required by database too" do
    student = sycamore_students(:valid_student)
    student.code = nil
    
    assert_raises(ActiveRecord::StatementInvalid) {
      student.save(validate: false)
    }
  end
  
  test "active scope only returns active students" do
    regular_student = sycamore_students(:valid_student)
    deleted_student = Sycamore::Student.create!(id: 12345, code: "Deleted Student Code", deleted_at: Time.now - 1.minutes)
  
    assert_equal 2, Sycamore::Student.count
    assert_equal 1, Sycamore::Student.active.count
  end
  
  test "deleted scope only returns deleted students" do
    regular_student = sycamore_students(:valid_student)
    deleted_student = Sycamore::Student.create!(id: 12345, code: "Deleted Student Code", deleted_at: Time.now - 1.minutes)
  
    assert_equal 2, Sycamore::Student.count
    assert_equal 1, Sycamore::Student.deleted.count
  end
  
  test "student record can optionally belong to person" do
    student = sycamore_students(:valid_student)
    assert_nil student.person # optional
  
    student.update(person: people(:valid_person))
  
    assert_equal people(:valid_person).sis_students.first, student
  end
end
