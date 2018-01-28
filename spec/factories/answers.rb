FactoryGirl.define do
  factory :answer do
    body "MyAnswerBody"
    question
    user

    factory :invalid_answer do
      body nil
      question nil
    end
  end
end
