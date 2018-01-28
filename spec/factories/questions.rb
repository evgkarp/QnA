FactoryGirl.define do
  factory :question do
    title "MyQuestionTitle"
    body "MyQuestionBody"
    user

    factory :invalid_question do
      title nil
      body nil
    end
  end
end
