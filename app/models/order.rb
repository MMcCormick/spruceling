class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  validates_presence_of :user

  def self.process(user)

  end
end