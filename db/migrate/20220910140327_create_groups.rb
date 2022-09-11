class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.string :dir_id
      t.string :dir_name
      t.string :dir_email
      t.string :dir_description
      t.string :dir_aliases, null: false, array:true, default: []

      t.timestamps
    end
    
    add_index :groups, :name
    add_index :groups, :dir_id, unique: true
    add_index :groups, :dir_name
    add_index :groups, :dir_email
  end
end
