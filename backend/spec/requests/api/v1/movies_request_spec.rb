require 'rails_helper'

RSpec.describe 'Api::V1::Movies' do
  let(:json_body) { response.parsed_body }
  let!(:user) { create(:user) }
  let(:token) { generate_jwt(user) }
  let(:headers) { { 'Host' => 'example.com', 'Content-Type' => 'application/json' } }
  let(:headers_login) { { 'Host' => 'example.com', 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{token}" } }

  describe 'Get list movies' do
    let(:json_body) { response.parsed_body }
    subject { get api_v1_movies_path, params: params.to_json, headers: }
    let(:params) { {} }

    context 'when get list movies successfully' do
      let!(:movie) { create(:movie, user: user, url: 'https://www.youtube.com/watch?v=1PgE4XjmHEY') }

      it 'Get success movies' do
        expect(subject).to eq 200
      end

      it 'have data movie and meta' do
        subject

        expect(json_body['movies'].length).to eq 1
        expect(json_body['meta']['total_count']).to eq 1
      end
    end
  end

  describe 'Create new movie' do
    subject { post api_v1_movies_path, params: params.to_json, headers: }
    let(:json_body) { response.parsed_body }

    let(:params) do
      {
        "movie": {
          "url": "https://www.youtube.com/watch?v=1PgE4XjmHEY"
        }
      }
    end

    context "when the user don't login" do
      it 'Get status 401' do
        expect(subject).to eq 401
      end
    end

    context 'when the user login and create fail movie' do
      let(:headers) { headers_login }

      let(:params) do
        {
          "movie": {
            "url": "http://example.com"
          }
        }
      end
      context 'when create successfully' do
        it 'successfully creates' do
          subject
          expect(subject).to eq 422
        end
      end
    end

    context 'when the user login and create new movie' do
      let(:headers) { headers_login }
      context 'when create successfully' do
        it 'successfully creates' do
          subject
          expect(subject).to eq 201
        end

        it 'compare url' do
          subject
          expect(json_body['url']).to eq 'https://www.youtube.com/watch?v=1PgE4XjmHEY'
        end
      end
    end
  end
end
