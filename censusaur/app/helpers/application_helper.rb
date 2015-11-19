module ApplicationHelper
  def hide_zero(val)
    if val.to_i == 0
      "---"
    else
      val
    end
  end

  def show_as_i(val)
    val.to_i
  end

  def show_as_options(string)
    if string.match(/-/).present? == true
      string_array = string.split("-")
      result_array = []
      string_array.each do |string|
        result_array << string[0].upcase + string[1..-1]
      end
      result_array.join("/")
    else
      string
    end
  end

  def strip_hyphens(string)
    if string.match(/-/).present? == true
      string.gsub(/-/, " ")
    else
      string
    end
  end

  def yes_no(val)
    if val === true
      "Yes"
    else
      "---"
    end
  end
end
