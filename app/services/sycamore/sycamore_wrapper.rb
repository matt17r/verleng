module Sycamore # class Sycamore::SycamoreWrapper
  class SycamoreWrapper < ApplicationService
    def initialize
      raise "This is an abstract class. Please use a subclass."
    end

    def call
      raise ArgumentError.new("@url not defined in subclass") unless @url
      raw_data = connection.get(@url)
      raise NoContentError.new("Not found") if raw_data.status == 204
      raise "Status #{raw_data.status}#{" (" + raw_data.body + ")" if raw_data.body.present?}" if raw_data.status != 200
      result = JSON.parse(raw_data.body)
    rescue => e
      OpenStruct.new({success?: false, error: e})
    else
      OpenStruct.new({success?: true, payload: result})
    end

    private

    def connection
      @connection ||= Faraday.new(url: url_base, headers: headers)
    end

    def url_base
      "https://app.sycamoreschool.com/api/v1"
    end

    def headers
      {authorization: "Bearer #{ENV["SYCAMORE_TOKEN"]}"}
    end
  end

  class NoContentError < StandardError; end
end
