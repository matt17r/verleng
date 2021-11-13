require "application_system_test_case"
require "test_helper"
require "action_mailer/test_helper"

class UserSignUpFlowTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  test "Sign up for a user account" do
    time = Time.now
    email = "test_user_#{time.to_s(:number)}@example.com"
    password = "Password#{time.to_s(:number)}!"

    # Sign up (sends confirmation email)
    visit sign_up_url
    fill_in I18n.t("helpers.label.user.email"), with: email
    fill_in I18n.t("helpers.label.user.password"), with: password
    assert_emails 1 do
      click_on I18n.t("helpers.submit.user.create")
      sleep 1 # Not sure why this is required... Hotwire/Turbo glitch?
    end
    assert_selector "span", text: I18n.t("flashes.confirmation_pending")

    # Confirm
    last_email = ActionMailer::Base.deliveries.last
    parsed_email = Nokogiri::HTML(last_email.body.decoded)
    target_link = parsed_email.at("a:contains('#{I18n.t("clearance_mailer.confirm_email.link_text")}')")
    visit hacky_way_to_fix_incorrect_port(target_link["href"])
    assert_selector "span", text: I18n.t("flashes.email_confirmed")

    # Log in and check (by presence of log out button)
    fill_in I18n.t("helpers.label.session.email"), with: email
    fill_in I18n.t("helpers.label.session.password"), with: password
    click_on I18n.t("helpers.submit.session.submit")
    assert_selector "button", text: "#{I18n.t("layouts.application.sign_out")}: #{email}"
  end

  private

  def hacky_way_to_fix_incorrect_port(url)
    uri = URI(url)
    "#{root_url}#{uri.path}"
  end
end
