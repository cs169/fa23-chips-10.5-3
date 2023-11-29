# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'instance methods' do
    describe '#name' do
      it 'returns the full name of the user' do
        user = User.create(provider: 'google_oauth2', uid: 'google_uid', first_name: 'Gavin', last_name: 'Newsom')
        expect(user.name).to eq('Gavin Newsom')
      end
    end

    describe '#auth_provider' do
      it 'returns the authentication provider name' do
        user = User.create(provider: 'google_oauth2', uid: 'google_uid', first_name: 'John', last_name: 'Doe')
        expect(user.auth_provider).to eq('Google')
      end
    end
  end

  describe 'class methods' do
    describe '.find_google_user' do
      it 'finds a user by UID and Google provider' do
        google_user = User.create(provider: 'google_oauth2', uid: 'google_uid', first_name: 'John', last_name: 'Doe')

        found_user = User.find_google_user('google_uid')

        expect(found_user).to eq(google_user)
      end

      it 'returns nil when no user is found for the given UID and Google provider' do
        non_existent_uid = 'non_existent_uid'

        found_user = User.find_google_user(non_existent_uid)

        expect(found_user).to be_nil
      end
    end

    describe '.find_github_user' do
      it 'finds a user by UID and Github provider' do
        github_user = User.create(provider: 'github', uid: 'github_uid', first_name: 'John', last_name: 'Doe')

        found_user = User.find_github_user('github_uid')

        expect(found_user).to eq(github_user)
      end

      it 'returns nil when no user is found for the given UID and Github provider' do
        non_existent_uid = 'non_existent_uid'

        found_user = User.find_github_user(non_existent_uid)

        expect(found_user).to be_nil
      end
    end
  end
end