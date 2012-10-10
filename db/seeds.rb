# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'SETTING UP DEFAULT USER LOGIN'
unless User.where(:email => 'user@example.com').first
  user = User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'
  puts 'New user created: ' << user.name
end
unless User.where(:email => 'user2@example.com').first
  user2 = User.create! :name => 'Second User', :email => 'user2@example.com', :password => 'please', :password_confirmation => 'please'
  puts 'New user created: ' << user2.name
end

puts 'Creating clothing types'

item_types = {
  "Long-sleeve" => [["Button Downs", "Long-sleeve Button Downs"], ["Polos", "Long-sleeve Polos"], ["Sweaters", "Sweaters"], ["T Shirts", "Long-sleeve T Shirts"]],
  "Short-sleeve" => [["Button Downs", "Short-sleeve Button Downs"], ["Polos", "Short-sleeve Polos"], ["Sweater Vests", "Sweater Vests"], ["T Shirts", "Short-sleeve T Shirts"], ["Tank Tops", "Tank Tops"]],
  "Pants" => [["Capris", "Capris"], ["Chinos / Khakis", "Chino / Khaki Pants"], ["Cords", "Cords"], ["Jeans", "Jeans"], ["Leggings", "Leggings"], ["Overalls", "Overalls"], ["Snow Pants", "Snow Pants"], ["Sweatpants / Windpants", "Sweatpants / Windpants"]],
  "Shorts" => [["Cargo", "Cargo Shorts"], ["Denim", "Denim Shorts"], ["Khaki / Cotton", "Khaki / Cotton Shorts"], ["Overalls", "Overall Shorts"]],
  "Skirts" => [["Long Skirts", "Long Skirts"], ["Short Skirts", "Short Skirts"], ["Skorts", "Skorts"]],
  "Dresses" => [["Long Dresses", "Long Dresses"], ["Short Dresses", "Short Dresses"]],
  "Onesies" => [["Onesies", "Onesies"], ["Rompers", "Rompers"], ["Snow Suits", "Snow Suits"]],
  "Sleepwear" => [["Nightgowns", "Nightgowns"], ["Pajama Sets", "Pajama Sets"], ["Pajama Bottoms", "Pajama Bottoms"], ["Pajama Tops", "Pajama Tops"]],
  "Jackets" => [["Blazers", "Blazers"], ["Coats / Warm Jackets", "Coats / Warm Jackets"], ["Hoodies", "Hoodies"], ["Raincoats", "Raincoats"], ["Sweatshirts", "Sweatshirts"], ["Raincoats", "Raincoats"], ["Vests", "Vests"]]
}

item_types.each do |category, names|
  names.each do |name|
    ItemType.create :category => category, :short_name => name[0], :name => name[1]
  end
end