class Box
  include Mongoid::Document
  include Mongoid::Timestamps

  field :gender, :type => String
  field :size, :type => String
  field :item_type_ids, :type => Array, :default => []
  field :status, :type => String, :default => "active"

  has_attachments :photos, maximum: 10

  belongs_to :user
  has_many :items

  validates_presence_of :gender, :size, :user
  attr_accessible :gender, :size

  scope :active, where(:status => "active")

  def add_item(item)
    if item.box || item.gender != gender || item.size != size
      false
    else
      self.items << item
      self.item_type_ids << item.item_type_id unless item_type_ids.include? item.item_type_id
    end
  end

  def remove_item(item)
    self.items.delete(item)
    self.item_type_ids.delete(item.item_type_id) if items.where(:item_type_id => item.item_type_id).empty?
  end

  def self.by_filter(params={})
    query = {}
    query[:gender] = params[:gender] if ["m", "f"].include? params[:gender]
    query[:size] = params[:size] if Item.all_sizes.include? params[:size]
    Box.where(query)
  end

  def weight
    total = 0
    items.each do |item|
      total += item.weight
    end
    total
  end
end