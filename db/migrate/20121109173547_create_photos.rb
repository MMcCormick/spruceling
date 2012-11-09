class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :imageable_id
      t.integer :imageable_type
      t.string :image

      t.timestamps
    end
  end
end
