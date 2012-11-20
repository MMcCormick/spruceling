class CreateCart < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.references :user
    end

    add_index :carts, :user_id
  end
end
