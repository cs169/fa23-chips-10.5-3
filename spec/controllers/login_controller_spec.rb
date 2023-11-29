# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  describe 'google' do
    before do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    it 'login' do
      get :google_oauth2
      expect(response.status).to redirect_to('/')
      expect(session[:current_user_id]).to eq(1)
    end
  end

  describe 'github' do
    before do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
    end

    it 'login' do
      get :github
      expect(response.status).to redirect_to('/')
      expect(session[:current_user_id]).to eq(1)
    end
  end

  it 'login' do
    get :login
    expect(response.status).to eq(200)
  end

  describe 'after successful login' do
    before do
      user = User.create(
        uid:        23,
        provider:   User.providers[:google_oauth2],
        first_name: 'First',
        last_name:  'Last',
        email:      'fake@email.com'
      )
      session[:current_user_id] = user.id
    end

    it 'login twice' do
      get :login
      expect(response).to redirect_to('/user/profile')
    end

    it 'logout' do
      get :logout
      expect(session[:current_user_id]).to be_nil
    end
  end
end
