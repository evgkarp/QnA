FactoryBot.define do
  factory :authorization do
    user nil
    provider "MypProvider"
    uid "MyUid"
  end
end
