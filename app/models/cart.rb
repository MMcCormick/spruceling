class Cart < ActiveRecord::Base

  belongs_to :user
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
end
