desc "Hi ThredUP"
task :fuck_thredup => :environment do
  ThredupData.fetch_all
end

task :create_brands_from_thredup => :environment do
  ThredupData.order('brand_name ASC').all.each do |data|
    unless data.brand_name
      puts 'delete row'
      data.delete
      next
    end
    brand = Brand.where(:slug => data.brand_name.parameterize).first
    unless brand
      brand = Brand.create(:name => data.brand_name)
      puts "brand #{brand.name}"
    end
    data.brand = brand
    data.save
  end
end