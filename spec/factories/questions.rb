FactoryGirl.define do
  factory :question do
    title "MyStringTitle"
    body "MyTextBody"

    factory :invalid_question do
      title nil
      body nil
    end
  end
end
