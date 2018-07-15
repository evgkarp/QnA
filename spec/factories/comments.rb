FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "MyCommentBody #{n}" }
  end
end
