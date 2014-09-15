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
        post :create, order: {user_id: @user.id, from: 'A restaurant'}
      }.to change(Order, :count)
    end

    it 'redirects to dashboard after' do
      sign_in @user
      post :create, order: {user_id: @user.id, from: 'A restaurant'}
      expect(response).to redirect_to dashboard_users_path
    end

    it 'redirects to index when not logged in' do
      post :create
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET edit' do
    before do
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save
    end
    it 'renders edit page' do
      sign_in @user
      get :edit, id: @order.id
      expect(response).to render_template :edit
    end

    it 'redirects to index when not logged in' do
      get :edit, id: @order.id
      expect(response).to redirect_to root_path
    end
  end

  describe 'PUT update' do
    before do
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save
    end
    it 'redirects to dashboard after' do
      sign_in @user
      put :update, id: @order.id, order: {user_id: @user.id}
      expect(response).to redirect_to dashboard_users_path
    end

    it 'redirects to index when not logged in' do
      put :update, id: @order.id
      expect(response).to redirect_to root_path
    end
  end

  describe 'PUT change_status' do
    before do
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save
    end
    it 'redirects to dashboard after' do
      sign_in @user
      put :change_status, id: @order.id
      expect(response).to redirect_to dashboard_users_path
    end
    it 'redirects to index when not logged in' do
      put :update, id: @order.id
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET shipping' do
    before do
      @order = build(:order) do |order|
        order.user = @user
      end
      @order.save
    end
    it 'is success' do
      sign_in @user
      get :shipping, id: @order.id
      expect(response).to render_template :shipping
    end
  end
end
