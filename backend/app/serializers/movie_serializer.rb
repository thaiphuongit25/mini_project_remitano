# frozen_string_literal: true

class MovieSerializer < ActiveModel::Serializer
  attributes :id,
             :user_id,
             :youtube_id,
             :title,
             :description,
             :thumbnail_url,
             :url
  belongs_to :user
end
