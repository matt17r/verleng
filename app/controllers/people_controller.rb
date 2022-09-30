class PeopleController < ApplicationController
  before_action :require_login
  before_action :set_person, only: %i[show destroy]

  def index
    @people = Person.sorted_by_name
  end

  def show
  end

  def destroy
    @person.destroy
    redirect_to people_url, notice: "Person was successfully destroyed."
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params
      .require(:person)
      .permit(:official_given_name, :official_family_name, :preferred_given_name, :preferred_family_name,
        :local_given_name, :local_family_name, :other_given_names, :display_name, :formal_name, :sort_name,
        :additional_name_details, :date_of_birth, :gender, :school_email, :personal_email, :school_phone,
        :personal_phone, :other_contact_details)
  end
end
