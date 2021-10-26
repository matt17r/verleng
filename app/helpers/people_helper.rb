module PeopleHelper
  def name_info(person)
  end

  def show_avatar(person)
    initials = person.display_name.split(" ").map(&:first).join
    render "avatar", text: initials, classes: [bg_colour(initials), text_colour(initials), text_size(initials)]
  end

  private

  COLOUR_PAIRS = [
    {bg: "bg-blue-500", text: "text-gray-100"},
    {bg: "bg-green-500", text: "text-gray-100"},
    {bg: "bg-indigo-500", text: "text-gray-100"},
    {bg: "bg-pink-500", text: "text-gray-100"},
    {bg: "bg-purple-500", text: "text-gray-100"},
    {bg: "bg-red-500", text: "text-gray-100"},
    {bg: "bg-yellow-500", text: "text-gray-100"}
  ]

  def bg_colour(initials)
    COLOUR_PAIRS[initials.hash % COLOUR_PAIRS.size][:bg]
  end

  def text_colour(initials)
    COLOUR_PAIRS[initials.hash % COLOUR_PAIRS.size][:text]
  end

  def text_size(initials)
    case initials.length
    when 1
      "text-2xl"
    when 2
      "text-xl"
    when 3
      "text-lg"
    else
      "text-base"
    end
  end
end
