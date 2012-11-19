# == Schema Information
#
# Table name: boxes
#
#  gender       :string(255)
#  id           :integer          not null, primary key
#  seller_price :decimal(8, 2)
#  size         :string(255)
#  status       :string(255)      default("active")
#  user_id      :integer
#

class Box < ActiveRecord::Base

  has_many :photos,  :as => :imageable, :dependent => :destroy

  belongs_to :user, :inverse_of => :boxes
  has_many :items, :inverse_of => :box
  has_one :order_item, :inverse_of => :box
  has_one :order, :through => :order_item

  accepts_nested_attributes_for :items, :limit => 20

  validates_presence_of :gender, :size, :user
  attr_accessible :gender, :size, :seller_price, :items_attributes
  validates :seller_price, :numericality => {:greater_than_or_equal_to => 1, :less_than_or_equal_to => 1000}, :if => lambda { |box| box.is_active? }
  validates :photos, :presence => true, :if => lambda { |box| box.is_active? && Rails.env != "test" }
  validates :rating, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 5}, :unless => lambda { |box| box.rating.nil? }

  scope :active, where(:status => "active")

  def is_active?
    status == 'active' ? true : false
  end

  def add_item(item)
    if item.box || item.gender != gender || item.size != size
      false
    else
      self.items << item
    end
  end

  def remove_item(item)
    self.items.delete(item)
  end

  def gender_noun
    {
      'm' => 'Boys',
      'f' => 'Girls'
    }[gender]
  end

  def self.by_filter(params={})
    query = {}
    query[:gender] = params[:gender] if ["m", "f"].include? params[:gender]
    query[:size] = params[:size] if Item.all_sizes.include? params[:size]
    query[:user_id] = params[:user_id] if query[:user_id]
    Box.includes({:items => :item_type}, :user).where(query)
  end

  def weight
    total = 0
    items.each do |item|
      total += item.weight
    end
    total
  end

  def item_type_counts
    counts = {}
    self.items.each do |i|
      counts[i.item_type.name] ||= 0
      counts[i.item_type.name] += 1
    end
    counts
  end

  def price_total
    (seller_price ? seller_price + 12 : 0)
  end

  def recommended_price
    @recommended ||= calculate_recommended_price
  end

  private

  def calculate_recommended_price
    prices = {:retail => 0, :consignment => 0}
    brands = {}
    items.each do |item|
      brands[item.brand_id] ||= 0
      brands[item.brand_id] += 1
    end

    price_data = ThredupData.select('brand_id, AVG(retail_price) as retail_average, AVG(thredup_price) as consignment_average')
    .where(:brand_id => brands.keys)
    .group('brand_id').to_a

    brands.each do |brand_id,brand_count|
      data = price_data.detect{|pd| pd.brand_id == brand_id}
      if data
        prices[:retail] += (data.retail_average.to_f * brand_count).ceil
        prices[:consignment] += (data.consignment_average.to_f * brand_count).ceil
      else
        prices[:retail] += (20 * brand_count).ceil
        prices[:consignment] += (7 * brand_count).ceil
      end
    end

    prices[:savings] = seller_price && prices[:retail] > 0 ? ((1 - (price_total / prices[:retail])) * 100).floor : nil
    prices[:recommended_high] = (prices[:consignment] * 0.6).ceil
    prices[:recommended_low] = (prices[:consignment] * 0.2).ceil
    prices
  end
end
