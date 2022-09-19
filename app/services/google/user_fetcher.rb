module Google # class Google::UserFetcher
  class UserFetcher < ApplicationService
    def initialize(user_key:)
      scope = [ "https://www.googleapis.com/auth/admin.directory.user.readonly" ]
      user = Rails.application.credentials.google.user
      @url = "https://admin.googleapis.com/admin/directory/v1/users/#{user_key}?fields=id,primaryEmail,name,suspended,aliases,nonEditableAliases,orgUnitPath,includeInGlobalAddressList"
      
      auth = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: StringIO.new(Rails.application.credentials.google.credentials),
        scope: scope
      )
      auth.sub = user
      auth.fetch_access_token!
      @access_token = auth.access_token
    end
    
    def call
      http_client = Faraday.new(headers: { "Content-Type" => "application/json", "Authorization" => "Bearer #{@access_token}" }, request: { timeout: 5 }) do |f|
        f.request(:json)
        f.response :json, parser_options: { symbolize_names: true }
      end
      response = http_client.get(@url)
      raise StandardError, response.body[:error] unless response.success?
    rescue => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true, payload: response.body})
    end
  end
end
