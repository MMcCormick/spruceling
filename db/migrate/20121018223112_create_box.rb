class CreateBox < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.string :gender
      t.string :size
      t.string :status, :default => 'active'
      t.references :user
    end

    add_index :boxes, :size
    add_index :boxes, :user_id
  end
end
