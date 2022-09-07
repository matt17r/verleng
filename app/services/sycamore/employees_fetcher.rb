module Sycamore # class Sycamore::EmployeesFetcher
  class EmployeesFetcher < SycamoreWrapper
    def initialize(name_filter: nil)
      @url = "School/2916/Employees#{"?filter=" + name_filter if name_filter}"
    end
  end
end
