# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'validation' do
    describe 'validations' do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to have_many(:movies) }
    end

    context 'association' do
      it { is_expected.to have_many(:movies).dependent(:destroy) }
    end

    context 'format email' do
      let(:user) { build :user, email: 'test@gamil.com' }
      let(:user1) { build :user, email: 'test' }
      before do
        user.valid?
        user1.valid?
      end

      it 'the email is valid' do
        expect(user.errors.messages.empty?).to eq true
      end

      it 'the email is invalid' do
        expect(user1.errors.messages[:email]).to eq ['is invalid', 'is wrong format']
      end
    end
  end
end
