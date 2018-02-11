FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "MyQuestionTitle #{n}" }
    body "MyQuestionBody"
    user

    factory :invalid_question do
      title nil
      body nil
    end
  end
end
