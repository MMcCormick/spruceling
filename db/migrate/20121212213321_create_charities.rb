class CreateCharities < ActiveRecord::Migration
  def change
    create_table :charities do |t|
      t.string :name
      t.string :site
      t.string :status
      t.decimal :goal, :precision => 8, :scale => 2
      t.decimal :balance, :precision => 8, :scale => 2
    end
  end
end
