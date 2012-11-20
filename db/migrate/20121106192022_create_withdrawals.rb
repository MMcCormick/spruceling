class CreateWithdrawals < ActiveRecord::Migration
  def change
    create_table :withdrawals do |t|
      t.decimal :amount, :precision => 8, :scale => 2, :null => false
      t.hstore :address, :null => false
      t.boolean :sent, :default => false, :null => false
      t.references :user

      t.timestamps
    end
    add_index :withdrawals, :user_id
  end
end