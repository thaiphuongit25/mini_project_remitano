# frozen_string_literal: true

require 'rails_helper'

RSpec.describe YoutubeLinkFormatValidator do
  let(:user) { User.new(email: 'john@gmail.com', password: '12345678') }
  let(:movie) { build(:movie, youtube_id: youtube_id, url: url) }

  context 'when valid youtube link' do
    let(:youtube_id) { 'LWtaPSKlHu8' }
    let(:url) { "https://www.youtube.com/watch?v=#{youtube_id}" }

    it 'is valid' do
      expect(movie).to be_valid
    end
  end

  context 'when invalid youtube link' do
    let(:url) { 'invalid_youtube_link' }
    let(:youtube_id) { 'invalid_youtube_id' }

    it 'is not valid' do
      expect(movie).not_to be_valid
      expect(movie.errors[:url]).to eq ['is not a valid YouTube URL', 'is invalid']
    end
  end
end
