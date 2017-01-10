FactoryGirl.define do
  factory :staff_member do
    sequence(:email) { |n| "member#{n}@example.com" }
    family_name '西島'
    given_name '誠'
    family_name_kana 'ニシジマ'
    given_name_kana 'マコト'
    password 'pw'
    start_date { Date.yesterday }
  end
end