class CreateDirectoryRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :directory_records do |t|
      t.references :person, type: :uuid, null: false, foreign_key: true
      t.string :directory_id, null: false
      t.string :email, null: false
      t.string :email_aliases, null: false, array: true, default: []
      t.string :org_unit, null: false
    
      t.timestamps
    end
    add_index :directory_records, :directory_id, unique: true
    add_index :directory_records, :email
  end
end
