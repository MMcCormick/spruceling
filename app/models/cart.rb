class Cart
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  has_and_belongs_to_many :boxes

  validates_presence_of :user

  def add_box(box_id)
    box = Box.find(box_id)
    if box
      self.boxes << box
      true
    else
      false
    end
  end

  def remove_box(box_id)
    box = Box.find(box_id)

    if box
      self.boxes.delete(box)
      true
    else
      false
    end
  end
end
