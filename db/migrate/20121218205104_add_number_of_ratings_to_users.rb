class AddNumberOfRatingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :number_of_ratings, :integer
  end
end
