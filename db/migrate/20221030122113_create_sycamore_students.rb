class CreateSycamoreStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :sycamore_students do |t|
      t.references :person, type: :uuid, foreign_key: true
      t.string :code, null: false
      t.string :given_name
      t.string :family_name
      t.string :preferred_name
      t.date :birthday
      t.string :gender
      t.string :location
      t.string :grade
      t.string :email
      t.string :phone
      t.integer :family_id
      t.integer :family2_id
      t.datetime :deleted_at

      t.timestamps
    end
    
    add_index :sycamore_students, :code
    add_index :sycamore_students, :given_name
    add_index :sycamore_students, :family_name
    add_index :sycamore_students, :preferred_name
    add_index :sycamore_students, :location
    add_index :sycamore_students, :grade
    add_index :sycamore_students, :email
    add_index :sycamore_students, :phone
    add_index :sycamore_students, :family_id
  end
end
