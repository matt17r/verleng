class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people, id: :uuid do |t|
      t.string :official_given_name
      t.string :official_family_name # or patronymic, matronymic, etc

      t.string :preferred_given_name
      t.string :preferred_family_name

      t.string :local_given_name
      t.string :local_family_name

      t.string :other_given_names
      t.string :display_name
      t.string :formal_name
      t.string :sort_name

      t.jsonb :additional_name_details # previous names, religious names, etc as JSON

      t.date :date_of_birth
      t.string :gender

      t.string :school_email
      t.string :personal_email
      t.string :school_phone
      t.string :personal_phone
      t.jsonb :other_contact_details # phone, email, social media, etc as JSON

      t.timestamps

      t.check_constraint "(official_given_name is not null or preferred_given_name is not null)", name: "given_name_check"
    end
  end
end
