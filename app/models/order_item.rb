# == Schema Information
#
# Table name: order_items
#
#  box_id         :integer
#  empty_tracking :string(255)
#  full_tracking  :string(255)
#  id             :integer          not null, primary key
#  order_id       :integer
#  paid           :boolean          default(FALSE)
#  status         :string(255)      default("pending")
#

# == Schema Information
#
# Table name: order_items
#
#  box_id   :integer
#  id       :integer          not null, primary key
#  order_id :integer
#  paid     :boolean          default(FALSE)
#  status   :string(255)      default("active")
#
include AwesomeUSPS

class OrderItem < ActiveRecord::Base

  belongs_to :box, :inverse_of => :order_item
  belongs_to :order, :inverse_of => :order_items

  validates_presence_of :box, :order, :status

  scope :pending, where(:status => "pending")

  def tracking_number
    status == "empty_box_shipped" ? empty_tracking : full_tracking
  end

  def empty_box_delivered
    OrderMailer.empty_box_delivered(id).deliver
    self.status = "empty_box_delivered"
    self.save
  end

  def full_box_shipped
    if paid
      raise "This user has already been paid"
    else
      if seller.credit_account(box.seller_price * Order.seller_cut)
        OrderMailer.full_box_shipped(id).deliver
        self.paid = true
        self.status = "full_box_shipped"
        self.save
        seller.save
        # Credit charity
        charity = Charity.where(:status => "active").last
        if charity
          charity.credit_account(box.seller_price * Order.charity_cut)
          charity.save
        end
      end
    end
  end

  def full_box_delivered
    OrderMailer.full_box_delivered(id).deliver
    self.status = "full_box_delivered"
    self.save
  end

  def self.track_boxes
    usps = USPS.new('209SPRUC6859')

    OrderItem.where(:status => ["empty_box_shipped", "empty_box_delivered", "full_box_shipped"]).each do |order_item|
      tracking = order_item.tracking_number
      raise "Missing Tracking Number" unless tracking
      case order_item.status
        when "empty_box_shipped"
          events = usps.track(tracking)
          order_item.empty_box_delivered if events.detect{|e| e[:event] == "DELIVERED"}
        when "empty_box_delivered"
          events = usps.track(tracking)
          order_item.full_box_shipped unless events.empty?
        when "full_box_shipped"
          events = usps.track(tracking)
          order_item.full_box_delivered if events.detect{|e| e[:event] == "DELIVERED"}
        else
          return
      end
    end
  end

  def self.all_statuses
    %w(pending empty_box_shipped empty_box_delivered full_box_shipped full_box_delivered)
  end

  def seller
    box.user
  end

  def buyer
    order.user
  end
end
