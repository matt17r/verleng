module Google # class Google::GroupMembersFetcher
  class GroupMembersFetcher < ApplicationService
    def initialize(group_key:)
      scope = [ "https://www.googleapis.com/auth/admin.directory.group" ]
      user = Rails.application.credentials.google.user
      @url = "https://admin.googleapis.com/admin/directory/v1/groups/#{group_key}/members?maxResults=200&fields=members(id,email,role,type),nextPageToken"

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
      get_pages(client: http_client)
    rescue => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true, payload: @results})
    end

    private

    def get_pages(client:, next_page_token: nil)
      @results ||= []
      url = next_page_token ? @url + "&pageToken=#{next_page_token}" : @url
      response = client.get(url)
      raise StandardError, response.body[:error] unless response.success?
      @results.push(*response.body[:members])
      get_pages(client: client, next_page_token: response.body[:nextPageToken]) if response.body[:nextPageToken].present?
    end
  end
end
