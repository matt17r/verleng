class CreateSycamoreContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :sycamore_contacts do |t|
      t.references :person, type: :uuid, foreign_key: true
      t.integer :family_id
      t.string :family_role
      t.string :given_name
      t.string :family_name
      t.string :email
      t.string :mobile_phone
      t.string :work_phone
      t.string :home_phone
      t.boolean :primary_parent
      t.boolean :authorised_pickup
      t.boolean :emergency_contact
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :sycamore_contacts, :given_name
    add_index :sycamore_contacts, :family_name
    add_index :sycamore_contacts, :email
    add_index :sycamore_contacts, :mobile_phone
  end
end
