# == Schema Information
#
# Table name: thredup_data
#
#  brand         :string(255)
#  gender        :string(255)
#  id            :integer          not null, primary key
#  item_type     :string(255)
#  new_with_tags :boolean          default(FALSE)
#  retail_price  :decimal(8, 2)
#  size          :string(255)
#  thredup_price :decimal(8, 2)
#  url           :string(255)
#

class ThredupData < ActiveRecord::Base

  belongs_to :brand

  def self.fetch_all(url='http://www.thredup.com')
    puts "*********** #{url} *************"

    agent = Mechanize.new
    agent.get(url)
    agent.page.parser.css('.item-list-single-item .item-list-top a:first').each do |item|
      fetch_item("http://www.thredup.com#{item['href']}")
    end

    if agent.page.parser.css('.bottom-nav .next_page').first
      fetch_all("http://www.thredup.com#{agent.page.parser.css('.bottom-nav .next_page').first['href']}")
    end
  end

  def self.fetch_item(url)
    return if ThredupData.where(:url => url).first

    agent ||= Mechanize.new

    begin
      agent.get(url)
    rescue
      puts 'NOT FOUND'
      return
    end

    data = {}
    data[:brand_name] = ActionView::Base.full_sanitizer.sanitize(agent.page.parser.css('.meta h5').text).strip
    data[:brand_name].strip if data[:brand_name]

    data[:gender] = ActionView::Base.full_sanitizer.sanitize(agent.page.parser.css('.meta .girls,.meta .boys').text)
    data[:gender].strip if data[:gender]

    data[:size] = ActionView::Base.full_sanitizer.sanitize(agent.page.parser.css('.meta .size').text).split(' ').last
    data[:size].strip if data[:size]

    data[:item_type] = ActionView::Base.full_sanitizer.sanitize(agent.page.parser.css('.top h3').text).gsub(data[:brand], '').strip
    data[:item_type].strip if data[:item_type]

    data[:thredup_price] = ActionView::Base.full_sanitizer.sanitize(agent.page.parser.css('.price-area .price').text).gsub('$', '').strip
    data[:thredup_price].strip if data[:thredup_price]

    data[:retail_price] = ActionView::Base.full_sanitizer.sanitize(agent.page.parser.css('.price-area .regular-price').text).gsub('$', '').strip
    data[:retail_price].strip if data[:retail_price]

    data[:new_with_tags] = agent.page.parser.css('.main .top .nwt').length == 0 ? false : true

    ThredupData.create(data.merge(:url => url))

    puts url
  end

end
