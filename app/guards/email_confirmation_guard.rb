class EmailConfirmationGuard < Clearance::SignInGuard
  def call
    if user_confirmed?
      next_guard
    else
      failure I18n.t("flashes.failure_when_email_not_confirmed")
    end
  end

  def user_confirmed?
    signed_in? && current_user.email_confirmed_at.present?
  end
end
