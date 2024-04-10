# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Sessions' do
  let(:json_body) { response.parsed_body }

  describe 'Register a user' do
    subject { post api_v1_sign_up_path, params: params.to_json, headers: }

    let(:headers) { { 'Host' => 'example.com', 'Content-Type' => 'application/json' } }

    let(:params) do
      {
        email: 'test@example.com',
        password: 'password-1234'
      }
    end

    context 'when the request is valid' do
      it 'create success with status 201' do
        expect(subject).to eq 201
      end

      it 'create success with correct data' do
        subject

        expect(json_body['token']).not_to be_nil
      end
    end

    context 'When the same user exists' do
      before do
        create(:user, params)
      end

      it 'status request 422' do
        expect(subject).to eq 422
      end
    end

    context 'when the email wrong' do
      let(:params) do
        {
          email: 'abc'
        }
      end

      it 'status request 422' do
        expect(subject).to eq 422
      end
    end

    context 'when the password empty' do
      let(:params) do
        {
          password: ''
        }
      end

      it 'status request 422' do
        expect(subject).to eq 422
      end
    end
  end

  describe 'When Login' do
    subject { post api_v1_sign_in_path, params: params.to_json, headers: }

    let(:headers) { { 'Host' => 'example.com', 'Content-Type' => 'application/json' } }

    let(:params) do
      {
        email: 'test1@example.com',
        password: '12345678'
      }
    end

    let!(:user) { create(:user, email: 'test1@example.com', password: '12345678' ) }

    context 'when the login is success' do
      it 'Login success with status 200' do
        expect(subject).to eq 200
      end

      it 'create success with correct data' do
        subject

        expect(json_body['token']).not_to be_nil
      end
    end

    context 'when the email wrong' do
      let(:params) do
        {
          email: 'abc'
        }
      end

      it 'status request 401' do
        expect(subject).to eq 401
      end
    end

    context 'when the password empty' do
      let(:params) do
        {
          password: ''
        }
      end

      it 'status request 401' do
        expect(subject).to eq 401
      end
    end
  end
end
