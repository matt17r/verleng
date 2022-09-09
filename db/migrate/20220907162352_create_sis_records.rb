class CreateSISRecords < ActiveRecord::Migration[7.0]
  def change
    create_enum :sis_record_type, %w(student staff contact)
    
    create_table :sis_records do |t|
      t.references :person, type: :uuid, null: false, foreign_key: true
      t.string :sis_id
      t.string :code
      t.string :family_id
      t.string :family_code
      t.string :student_grade
      t.enum :record_type, enum_type: :sis_record_type, null: false

      t.timestamps
    end
    add_index :sis_records, :code
    add_check_constraint :sis_records, "(sis_id is not null or code is not null)", name: "sis_identifier_check"
  end
end
