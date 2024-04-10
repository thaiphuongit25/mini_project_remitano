class Movie < ApplicationRecord
  belongs_to :user

  validates :url, youtube_link_format: true, presence: true
  validates :youtube_id, :title, presence: true
  validates :youtube_id, uniqueness: { case_sensitive: true }

  before_validation :set_youtube_data, if: -> { url.present? }

  private

  def set_youtube_data
    movie = VideoInfo.new(url)
    self.youtube_id = movie.video_id
    self.title = movie.title
    self.description = movie.description
  rescue VideoInfo::UrlError
    errors.add(:url, 'is not a valid YouTube URL')
  end
end
