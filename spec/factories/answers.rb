FactoryGirl.define do
  factory :answer do
    body "MyTextBody"
    question

    factory :invalid_answer do
      body nil
      question nil
    end
  end
end
