class CreateFamilyRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :family_relationships do |t|
      t.uuid :contact_id, null: false
      t.uuid :student_id, null: false
      
      t.timestamps
    end
    
    add_index :family_relationships, :contact_id
    add_index :family_relationships, :student_id
    add_index :family_relationships, [:student_id, :contact_id], unique: true
    
    add_foreign_key :family_relationships, :people, column: "student_id"
    add_foreign_key :family_relationships, :people, column: "contact_id"
  end
end
