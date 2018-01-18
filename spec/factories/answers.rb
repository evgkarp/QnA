FactoryGirl.define do
  factory :answer do
    body "MyTextBody"
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question nil
  end
end
