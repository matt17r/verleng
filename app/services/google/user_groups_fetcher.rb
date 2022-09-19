module Google # class Google::UserGroupsFetcher
  class UserGroupsFetcher < ApplicationService
    def initialize(email:)
      raise ArgumentError, "Email is required" unless email.present?
      scope = [ "https://www.googleapis.com/auth/admin.directory.group",
                "https://www.googleapis.com/auth/apps.groups.settings" ]
      user = Rails.application.credentials.google.user
      @url = "https://admin.googleapis.com/admin/directory/v1/groups?userKey=#{email}&maxResults=200&fields=groups(id,email,name,description,aliases)"
      
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
    rescue => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true, payload: response.body[:groups]})
    end
  end
end
