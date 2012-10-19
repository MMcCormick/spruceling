class CreateItemWeight < ActiveRecord::Migration
  def change
    create_table :item_weights do |t|
      t.string :name
      t.hstore :weights
    end

    change_column :item_weights, :weights, :text, :limit => nil
  end
end
