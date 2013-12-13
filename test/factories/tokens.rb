# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :token do
    feature_id 1
    user_id 1
    workstation_id 1
    handle 1
    uid "MyString"
    start "2013-11-22 14:25:47"
    stop "2013-11-22 14:25:47"
    slot 1
  end
end
