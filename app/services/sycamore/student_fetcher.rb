module Sycamore # class Sycamore::StudentFetcher
  class StudentFetcher < SycamoreWrapper
    def initialize(sis_id:)
      @url = "Student/#{sis_id}"
    end
  end
end
