desc "Hi ThredUP"
task :fuck_thredup => :environment do
  ThredupData.fetch_all
end