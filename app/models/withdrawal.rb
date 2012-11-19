# == Schema Information
#
# Table name: withdrawals
#
#  address    :hstore           not null
#  amount     :decimal(8, 2)    not null
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  sent       :boolean          default(FALSE), not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Withdrawal < ActiveRecord::Base
  serialize :address, ActiveRecord::Coders::Hstore

  belongs_to :user, :inverse_of => :withdrawals

  attr_accessible :address, :amount, :user

  validates_presence_of :amount, :address, :user
  validates_inclusion_of :sent, :in => [true, false]

  def self.generate(user)
    Withdrawal.new(:user => user, :amount => user.balance, :address => user.address)
  end
end
