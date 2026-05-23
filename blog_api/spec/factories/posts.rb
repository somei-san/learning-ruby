FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post Title #{n}" }
    body { "This is a sample post body." }
    association :user
  end
end
