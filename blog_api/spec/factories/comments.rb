FactoryBot.define do
  factory :comment do
    body { "Sample comment body" }
    association :post
    association :user
  end
end
