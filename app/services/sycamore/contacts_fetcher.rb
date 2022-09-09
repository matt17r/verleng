module Sycamore # class Sycamore::ContactsFetcher
  class ContactsFetcher < SycamoreWrapper
    def initialize(family_id:, primary_only: true)
      primary_param = primary_only ? 1 : 0
      
      @url = "Family/#{family_id}/Contacts?primary=#{primary_param}"
    end
  end
end
