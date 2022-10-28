class GWD::EmailContactsController < ApplicationController
  before_action :require_login
  before_action :set_gwd_email_contact, only: %i[ show destroy ]

  def index
    @gwd_email_contacts = GWD::EmailContact.active
  end

  def show
  end

  def destroy
    @gwd_email_contact.update!(deleted_at: Time.now)
    redirect_to gwd_email_contacts_url, notice: "Email Contact was successfully deleted."
  end

  private

  def set_gwd_email_contact
    @gwd_email_contact = GWD::EmailContact.find(params[:id])
  end

  def gwd_email_contact_params
    params.require(:gwd_email_contact).permit(:person_id, :email, :deleted_at)
  end
end
