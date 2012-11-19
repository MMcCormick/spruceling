# == Schema Information
#
# Table name: carts
#
#  id      :integer          not null, primary key
#  user_id :integer
#

class Cart < ActiveRecord::Base

  belongs_to :user, :inverse_of => :cart
  has_and_belongs_to_many :boxes

  validates_presence_of :user

  def add_box(box_id)
    begin
      box = Box.find(box_id)
    rescue
      return false
    end

    if box && box.user_id != user_id && !boxes.include?(box)
      self.boxes << box
      true
    else
      false
    end
  end

  def remove_box(box_id)
    begin
      box = Box.find(box_id)
    rescue
      return false
    end

    if box
      self.boxes.delete(box)
      true
    else
      false
    end
  end

  # Amount user must actually pay. Sum of Box price totals minus the user's balance
  def price_total
    total = boxes.map{|b|b.price_total}.inject(:+) - user.balance
    total < 0.5 ? 0.0 : total
  end

  def boxes_total
    total = boxes.map{|b|b.price_total}.inject(:+)
  end
end
