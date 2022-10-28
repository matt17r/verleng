class CreateGWDEmailContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :gwd_email_contacts, id: :string do |t|
      t.references :person, type: :uuid, foreign_key: true
      t.string :email, null: false
      t.date :deleted_at

      t.timestamps
    end

    add_index :gwd_email_contacts, :email
    add_index :gwd_email_contacts, :deleted_at
  end
end
