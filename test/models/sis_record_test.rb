require "test_helper"

class SISRecordTest < ActiveSupport::TestCase
  test "a code or sis_id is required" do
    record = sis_records(:valid_sis_record)
    
    record.code = nil
    record.sis_id = nil
    assert_not record.save, "Saved the SIS Record without any identifier"
  end
  
  test "a code or sis_id is required by the database too" do
    record = sis_records(:valid_sis_record)
    
    record.code = nil
    record.sis_id = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      record.save(validate: false)
    }
  end
  
  test "a record_type is required" do
    record = sis_records(:valid_sis_record)
  
    record.record_type = nil
    assert_not record.save, "Saved the SIS Record without a record type"
  end
  
  test "a record_type is required by the database too" do
    record = sis_records(:valid_sis_record)
    
    record.record_type = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      record.save(validate: false)
    }
  end
  
  test "record_type is restricted to accepted values" do
    accepted_values = %w(student staff contact)
    record = sis_records(:valid_sis_record)
    
    assert_nothing_raised {
      record.record_type = accepted_values.sample
    }
  
    assert_raises(ArgumentError) {
      record.record_type = "something else"
    }
    
  end
  
  test "record_type is restricted to accepted values by the database too" do
    accepted_values = %w(student staff contact)
    person_id = people(:valid_person).id
    table = Arel::Table.new(:sis_records)
    manager = Arel::InsertManager.new
    
    manager.insert [
      [table[:record_type], accepted_values.sample],
      [table[:person_id], person_id],
      [table[:sis_id], "2134"],
      [table[:created_at], Time.now],
      [table[:updated_at], Time.now],
    ]
    assert_nothing_raised {
      SISRecord.connection.insert(manager.to_sql)
    }
    
    manager.insert [
      [table[:record_type], "other type"],
      [table[:person_id], person_id],
      [table[:sis_id], "2134"],
      [table[:created_at], Time.now],
      [table[:updated_at], Time.now],
    ]
    assert_raises(ActiveRecord::StatementInvalid) {
      SISRecord.connection.insert(manager.to_sql)
    }
  end
end
