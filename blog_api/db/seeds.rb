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
  3.times do |i|
    attrs = {
      title: "#{user.name}'s post ##{i + 1}",
      body:  "..."
    }
    post = user.posts.find_or_create_by!(title: attrs[:title]) do |p|
  p.body = attrs[:body]
end
    post.update!(published: i.zero?)
  end
end
