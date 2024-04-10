# frozen_string_literal: true

FactoryBot.define do
  factory :movie do
    association :user
    youtube_id { Faker::Alphanumeric.alpha(number: 11) }
    url { Faker::Internet.url }
    title { Faker::Movie.title }
    description { Faker::Movie.quote }
  end
end
