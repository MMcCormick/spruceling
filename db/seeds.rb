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

weight_index

item_types = {
  "Long-sleeve" => [["Button Downs", "Long-sleeve Button Downs", "Long-sleeve Shirts"],
                    ["Polos", "Long-sleeve Polos", "Long-sleeve Shirts"],
                    ["Sweaters", "Sweaters", "Sweaters"],
                    ["T Shirts", "Long-sleeve T Shirts", "Long-sleeve Shirts"]],
  "Short-sleeve" => [["Button Downs", "Short-sleeve Button Downs", "Short-sleeve Shirts"],
                     ["Polos", "Short-sleeve Polos", "Short-sleeve Shirts"],
                     ["Sweater Vests", "Sweater Vests", "Sweater Vests"],
                     ["T Shirts", "Short-sleeve T Shirts", "Short-sleeve Shirts"],
                     ["Tank Tops", "Tank Tops"]],
  "Pants" => [["Capris", "Capris", "Pants"],
              ["Chinos / Khakis", "Chino / Khaki Pants", "Pants"],
              ["Cords", "Cords", "Pants"],
              ["Jeans", "Jeans", "Pants"],
              ["Leggings", "Leggings", "Pants"],   #Pants??
              ["Overalls", "Overalls", "Pants"],
              ["Snow Pants", "Snow Pants", "Pants"],
              ["Sweatpants / Windpants", "Sweatpants / Windpants"]],
  "Shorts" => [["Cargo", "Cargo Shorts", "Shorts"],
               ["Denim", "Denim Shorts", "Shorts"],
               ["Khaki / Cotton", "Khaki / Cotton Shorts", "Shorts"],
               ["Overalls", "Overall Shorts", "Overalls"]],
  "Skirts" => [["Long Skirts", "Long Skirts", "Skirts"],
               ["Short Skirts", "Short Skirts", "Skirts"],
               ["Skorts", "Skorts", "Skirts"]],
  "Dresses" => [["Long Dresses", "Long Dresses", "Dresses"],
                ["Short Dresses", "Short Dresses", "Dresses"]],
  "Onesies" => [["Onesies", "Onesies", "Onesies"],
                ["Rompers", "Rompers", "Onesies"],
                ["Snow Suits", "Snow Suits", "Snow Suits"]],
  "Sleepwear" => [["Nightgowns", "Nightgowns", "Onesies"],
                  ["Pajama Sets", "Pajama Sets", "Onesies"],
                  ["Pajama Bottoms", "Pajama Bottoms", "Pants"],
                  ["Pajama Tops", "Pajama Tops", "Long-sleeve Shirts"]],
  "Jackets" => [["Blazers", "Blazers", "Jackets"],
                ["Coats / Warm Jackets", "Coats / Warm Jackets", "Jackets"],
                ["Hoodies", "Hoodies", "Jackets"],
                ["Raincoats", "Raincoats", "Jackets"],
                ["Sweatshirts", "Sweatshirts", "Jackets"],
                ["Raincoats", "Raincoats", "Jackets"],
                ["Vests", "Vests", "Sweater Vests"]]
}

item_types.each do |category, names|
  names.each do |name|
    ItemType.create :category => category, :short_name => name[0], :name => name[1]
  end
end