# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

### Item Weights ###

unless ItemWeight.where(:name => "Long-sleeve Shirts").first
  puts 'Creating item weights'
  ItemWeight.create(name: "Dresses", weights: {"12 months"=>5.0, "24 months"=>7.0, "3T"=>10.0, "5"=>12.0, "6X"=>13.5, "8"=>16, "16"=>19, "20"=>22.0})
  ItemWeight.create(name: "Jackets", weights: {"12 months"=>10.0, "18 months"=>14.0, "2T"=>20.0, "5"=>12.9, "6X"=>14.1, "8"=>15.2, "12"=>17.2, "16"=>19.2, "20"=>22.0})
  ItemWeight.create(name: "Long-sleeve Shirts", weights: {"12 months"=>3.2, "24 months"=>3.6, "3T"=>4.0, "5"=>5.0, "6X"=>6.0, "8"=>7.0, "12"=>7.5, "16"=>8.2, "20"=>10.0})
  ItemWeight.create(name: "Pants", weights: {"12 months"=>3.1, "24 months"=>7.1, "3T"=>7.9, "4"=>13.4, "5"=>14.4, "6X"=>16.5, "7"=>17.5, "10"=>18.5, "14"=>19.2, "16"=>20.2, "20"=>22.0})
  ItemWeight.create(name: "Polos", weights: {"12 months"=>3.3, "24 months"=>3.6, "3T"=>4.0, "5"=>5.6, "8"=>7.4, "12"=>8.6, "16"=>9.3, "20"=>11.0})
  ItemWeight.create(name: "Onesies", weights: {"12 months"=>5.0, "18 months"=>9.0, "3T"=>10.5, "4"=>12.0, "6X"=>14.0, "8"=>8.9, "12"=>11.5, "16"=>13.0, "20"=>15.0})
  ItemWeight.create(name: "Overalls", weights: {"12 months"=>3.8, "18 months"=>6.0, "3T"=>8.0, "8"=>22.0, "14"=>27.0, "16"=>28.0, "20"=>32.0})
  ItemWeight.create(name: "Shorts", weights: {"12 months"=>3.0, "18 months"=>3.6, "3T"=>3.9, "5"=>7.0, "6X"=>8.0, "8"=>8.8, "10"=>9.2, "14"=>9.6, "16"=>20.4, "20"=>22.0})
  ItemWeight.create(name: "Skirts", weights: {"12 months"=>3.2, "18 months"=>3.5, "3T"=>3.7, "4"=>4.0, "6X"=>6.0, "8"=>8.0, "16"=>10.0, "20"=>12.0})
  ItemWeight.create(name: "Sweaters", weights: {"12 months"=>5.0, "18 months"=>5.0, "3T"=>5.5, "5"=>8.9, "6X"=>9.9, "8"=>10.7, "12"=>11.7, "16"=>14.5, "20"=>17.0})
  ItemWeight.create(name: "Short-sleeve Shirts", weights: {"12 months"=>3.5, "24 months"=>3.7, "3T"=>3.5, "5"=>3.7, "6X"=>3.9, "8"=>4.7, "12"=>5.4, "16"=>6.2, "20"=>7.5})
  ItemWeight.create(name: "Sweater Vests", weights: {"12 months"=>4.0, "24 months"=>4.6, "3T"=>5.0, "5"=>5.4, "6X"=> 6.1, "8"=>6.7, "12"=>8.0, "16"=>9.4, "20"=>15.0})

  ItemWeight.all.each do |item_weight|
    item_weight.fill_gaps
    item_weight.save
  end
end

## Item Brand ##
unless Brand.where(:name => "Kidztees").first
  Brand.create(:name => "Kidztees")
end

### Item Types ###

unless ItemType.where(:name => "Long-sleeve Polos").first
  puts 'Creating clothing types'
  item_types = {
    "Long-sleeve" => [["Button Downs", "Long-sleeve Button Downs", "Long-sleeve Shirts"],
                      ["Polos", "Long-sleeve Polos", "Long-sleeve Shirts"],
                      ["Sweaters", "Sweaters", "Sweaters"],
                      ["T Shirts", "Long-sleeve T Shirts", "Long-sleeve Shirts"]],
    "Short-sleeve" => [["Button Downs", "Short-sleeve Button Downs", "Short-sleeve Shirts"],
                       ["Polos", "Short-sleeve Polos", "Polos"],
                       ["Sweater Vests", "Sweater Vests", "Sweater Vests"],
                       ["T Shirts", "Short-sleeve T Shirts", "Short-sleeve Shirts"],
                       ["Tank Tops", "Tank Tops", "Short-sleeve Shirts"]],
    "Pants" => [["Capris", "Capris", "Pants"],
                ["Chinos / Khakis", "Chino / Khaki Pants", "Pants"],
                ["Cords", "Cords", "Pants"],
                ["Jeans", "Jeans", "Pants"],
                ["Leggings", "Leggings", "Pants"],   #Pants??
                ["Overalls", "Overalls", "Pants"],
                ["Snow Pants", "Snow Pants", "Pants"],
                ["Sweatpants / Windpants", "Sweatpants / Windpants", "Pants"]],
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
                  ["Rompers", "Rompers", "Onesies"]],
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
      w = ItemWeight.where(:name => name[2]).first
      ItemType.create :category => category, :short_name => name[0], :name => name[1], :item_weight_id => w.id
    end
  end
end