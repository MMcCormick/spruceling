# == Schema Information
#
# Table name: charities
#
#  balance :decimal(8, 2)
#  goal    :decimal(8, 2)
#  id      :integer          not null, primary key
#  name    :string(255)
#  site    :string(255)
#  status  :string(255)
#

class Charity < ActiveRecord::Base
  def percentage
    percent = (balance / goal * 100).round
    percent > 100 ? 100 : percent
  end

  def credit_account(amount)
    if amount > 0
      self.balance = balance + amount
      true
    else
      false
    end
  end
end
