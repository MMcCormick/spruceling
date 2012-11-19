module ApplicationHelper
  def title
    base_title = "Spruceling"
    title = truncate(@title, :length => 60, :separator => ' ')
    if @title.nil?
      base_title
    else
      "#{title} | #{base_title}"
    end
  end

  def description
    @description.nil? ? "Spruceling is the marketplace to buy and sell gently used kids clothing." : @description
  end
end
