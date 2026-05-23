# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

users = [
  { name: "Alice", email: "alice@example.com" },
  { name: "Bob",   email: "bob@example.com" },
  { name: "Carol", email: "carol@example.com" }
].map do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |u|
    u.name = attrs[:name]
  end
end

users.each do |user|
  next if user.posts.exists?

  3.times do |i|
    user.posts.create!(
      title: "#{user.name}'s post ##{i + 1}",
      body: "Sample body text for #{user.name}'s post number #{i + 1}."
    )
  end
end
