# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe 'validations' do
    context 'presence' do
      it { is_expected.to validate_presence_of(:youtube_id) }
      it { is_expected.to validate_presence_of(:url) }
    end

    context 'association' do
      it { should belong_to(:user) }
    end

    context 'format youtube link format' do
      let(:movie) { build :movie, url: 'https://www.youtube.com/watch?v=1PgE4XjmHEY' }
      let(:movie1) { build :movie, url: 'test fail youtube link format' }
      before do
        movie.valid?
        movie1.valid?
      end

      it 'the youtube link is valid' do
        expect(movie.errors.messages[:url].empty?).to eq true
      end

      it 'the youtube link is invalid' do
        expect(movie1.errors.messages[:url]).to eq ['is not a valid YouTube URL', 'is invalid']
      end
    end

    context 'when youtube id unique' do
      let(:user) { create :user }
      let(:movie) { create :movie, url: 'https://www.youtube.com/watch?v=1PgE4XjmHEY', user: user }
      let(:movie1) { build :movie, url: 'https://www.youtube.com/watch?v=1PgE4XjmHEY', youtube_id: movie.youtube_id }

      before do
        movie1.valid?
      end

      it 'the youtube id is already token' do
        expect(movie1.errors.messages[:youtube_id].first).to eq 'has already been taken'
      end
    end
  end
end
