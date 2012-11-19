class CreateItemWeight < ActiveRecord::Migration
  def change
    create_table :item_weights do |t|
      t.string :name
      t.hstore :weights
    end
  end
end
