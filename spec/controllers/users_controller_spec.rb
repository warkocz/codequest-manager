require 'spec_helper'

describe UsersController, type: :controller do
  describe 'GET #dashboard' do
    it 'shows dasboard to signed in user' do
      @user = create(:user)
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save!
      sign_in @user
      get :dashboard
      expect(response).to render_template :dashboard
    end

    it 'redirects not signed in user to root' do
      get :dashboard
      expect(response).to redirect_to root_path
    end
  end
end
