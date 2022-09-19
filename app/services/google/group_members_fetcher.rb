module Google # class Google::GroupMembersFetcher
  class GroupMembersFetcher < ApplicationService
    def initialize(group_key:)
      scope = [ "https://www.googleapis.com/auth/admin.directory.group",
                "https://www.googleapis.com/auth/apps.groups.settings" ]
      user = Rails.application.credentials.google.user
      @url = "https://admin.googleapis.com/admin/directory/v1/groups/#{group_key}/members?maxResults=200&fields=members(email,role,type)"
      
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
      raise StandardError, "No matching groups found" unless response.body[:members].present?
    rescue => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true, payload: response.body[:members]})
    end
  end
end
