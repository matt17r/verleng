module Sycamore # class Sycamore::StudentStatisticsFetcher
  class StudentStatisticsFetcher < SycamoreWrapper
    def initialize(sis_id:)
      @url = "Student/#{sis_id}/Statistics"
    end
  end
end
