require 'spec_helper'

describe OrdersController, :type => :controller do
  before do
    @user = create(:user)
  end
  describe 'GET new' do
    it 'renders new page' do
      sign_in @user
      get :new
      expect(response).to render_template :new
    end

    it 'redirects to index when not logged in' do
      get :new
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST create' do
    it 'creates an order' do
      sign_in @user
      expect {
        post :create, order: {orderer_id: @user.id}
      }.to change(Order, :count)
    end

    it 'redirects to dashboard after' do
      sign_in @user
      post :create, order: {orderer_id: @user.id}
      expect(response).to redirect_to users_dashboard_path
    end

    it 'redirects to index when not logged in' do
      post :create
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET edit' do
    it 'renders edit page' do
      sign_in @user
      get :edit
      expect(response).to render_template :edit
    end

    it 'redirects to index when not logged in' do
      get :edit
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST update' do
    it 'redirects to dashboard after' do
      sign_in @user
      post :update, order: {orderer_id: @user.id}
      expect(response).to redirect_to users_dashboard_path
    end

    it 'redirects to index when not logged in' do
      post :update
      expect(response).to redirect_to root_path
    end
  end
end
