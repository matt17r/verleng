class AddImageToGWDUser < ActiveRecord::Migration[7.0]
  def change
    add_column :gwd_users, :image, :string
    add_column :gwd_users, :image_etag, :string
  end
end
