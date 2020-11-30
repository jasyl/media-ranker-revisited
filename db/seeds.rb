require "csv"


media_file = Rails.root.join("db", "users_seeds.csv")

CSV.foreach(media_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  User.create!(data)
end





media_file = Rails.root.join("db", "media_seeds.csv")

CSV.foreach(media_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  data[:user_id] = User.all.sample.id
  puts data
  Work.create!(data)
end
