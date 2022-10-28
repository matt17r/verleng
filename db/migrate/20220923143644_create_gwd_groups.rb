class CreateGWDGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :gwd_groups, id: :string do |t|
      t.string :etag, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :description
      t.string :aliases
      t.date :deleted_at

      t.timestamps
    end

    add_index :gwd_groups, :name
    add_index :gwd_groups, :email
    add_index :gwd_groups, :deleted_at
  end
end
