class CreateGWDUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :gwd_users, id: :string do |t|
      t.references :person, type: :uuid, foreign_key: true
      t.string :etag, null: false
      t.string :given_name
      t.string :family_name
      t.string :full_name
      t.string :email, null: false
      t.string :email_aliases, null: false, array: true, default: []
      t.string :org_unit, null: false
      t.boolean :suspended, null: false
      t.date :deleted_at

      t.timestamps
    end

    add_index :gwd_users, :email
    add_index :gwd_users, :org_unit
    add_index :gwd_users, :suspended
    add_index :gwd_users, :deleted_at
  end
end
