class ExternalEmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value # skip validating if value is nil, this check should be handled by `presence: true`
    return record.errors.add attribute, "invalid" unless value.split("@").length == 2

    domain_portion = value.split("@").last
    record.errors.add attribute, (options[:message] || "is not an external email") if domain_portion.in? Rails.application.credentials.internal_domains
  end
end
