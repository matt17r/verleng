class CreateGroupMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :group_memberships do |t|
      t.references :group, null: false, foreign_key: true
      t.references :person, type: :uuid, null: false, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
