require 'spec_helper'

describe PagesController, type: :controller do

  describe 'GET #index' do
    it 'renders index page' do
      get :index
      expect(response).to render_template :index
    end

    it 'redirects logged in user to dashboard' do
      @user = create(:user)
      sign_in @user
      get :index
      expect(response).to redirect_to dashboard_users_path
    end
  end
end