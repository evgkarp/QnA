FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "MyAnswerBody #{n}" }
    question
    user

    factory :invalid_answer do
      body nil
      question nil
    end
  end
end
