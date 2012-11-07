class Withdrawal < ActiveRecord::Base
  belongs_to :user, :inverse_of => :withdrawals

  attr_accessible :address, :amount, :user

  validates_presence_of :amount, :address, :user
  validates_inclusion_of :sent, :in => [true, false]

  def self.generate(user)
    Withdrawal.new(:user => user, :amount => user.balance, :address => user.address)
  end
end
