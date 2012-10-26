# == Schema Information
#
# Table name: boxes
#
#  gender      :string(255)
#  id          :integer          not null, primary key
#  price_total :decimal(8, 2)
#  size        :string(255)
#  status      :string(255)      default("active")
#  user_id     :integer
#

class Box < ActiveRecord::Base

  has_attachments :photos, maximum: 10

  belongs_to :user, :inverse_of => :boxes
  has_many :items, :inverse_of => :box
  has_one :order_item, :inverse_of => :box
  has_one :order, :through => :order_item

  validates_presence_of :gender, :size, :user
  attr_accessible :gender, :size, :price_total
  validates :price_total, :numericality => {:greater_than => 1, :less_than => 1000}

  scope :active, where(:status => "active")

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
end
