class AddCampusToSISRecord < ActiveRecord::Migration[7.0]
  def change
    add_column :sis_records, :campus, :string
  end
end
