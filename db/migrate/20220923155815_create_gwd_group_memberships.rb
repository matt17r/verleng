class CreateGWDGroupMemberships < ActiveRecord::Migration[7.0]
  def change
    create_enum :group_role, %w(owner manager member)

    create_table :gwd_group_memberships, id: :string do |t|
      t.references :group, type: :string, null: false, index: true
      t.references :member, type: :string, null: false, polymorphic: true, index: true # add constraint to limit to user or group?
      t.string :email, null: false
      t.enum :role, enum_type: :group_role, null: false

      t.timestamps
    end
  end
end
