class ItemWeight
  include Mongoid::Document

  field :name
  field :weights, type: Hash, default: {}

  has_many :item_types

  validates_presence_of :name

  def get_weight(size)
    if Item.all_sizes.include? size
      weights[size]
    end
  end

  def fill_gaps
    lower = 2.0
    blank_sizes = []
    Item.all_sizes.each do |size|
      # If there is a recorded weight for this size
      if weights[size]
        # If there are blank sizes, fill them in
        unless blank_sizes.empty?
          blank_sizes.each_with_index do |blank_size, i|
            self.weights[blank_size] = lower + ((weights[size] - lower) / (blank_sizes.length + 1) * (i+1))
            #puts "#{blank_size} = #{lower} + (#{weights[size]} - #{lower} / #{blank_sizes.length + 1}) = #{weights[blank_size]}"
          end
        end
        # Set this size as the last known size
        lower = weights[size]
        blank_sizes = []
      else
        blank_sizes << size
      end

    end
  end
end