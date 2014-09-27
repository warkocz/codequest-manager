require 'spec_helper'

describe TransfersController, type: :controller do
  describe 'GET to new' do
    before do
      @user = create :user
    end
    it 'returns and renders' do
      sign_in @user
      get :new, user_id: @user.id
      expect(response).to render_template(:new)
      expect(response).to have_http_status(:success)
    end
    it 'redirects unsigned in to root' do
      get :new, user_id: @user.id
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST to create' do
    before do
      @user = create :user
      @other_user = create :other_user
    end
    it 'creates a transfer' do
      sign_in @other_user
      expect{
        post :create, user_id: @user.id, transfer: {amount: 14}
      }.to change(Transfer, :count).by(1)
    end
    it 'redirects unsigned in to root' do
      post :create, user_id: @user.id, transfer: {amount: 14}
      expect(response).to redirect_to root_path
    end
  end

  describe 'PUT to accept' do
    before do
      @user = create :user
      @other_user = create :other_user
      @transfer = build(:transfer) do |transfer|
        transfer.from = @user
        transfer.to = @other_user
      end
      @transfer.save!
    end
    it 'redirects to root if user is not the receiver of transfer' do
      sign_in @user
      put :accept, id: @transfer.id
      expect(response).to redirect_to root_path
    end
    it 'redirects to root if transfer is not pending' do
      @transfer.accepted!
      sign_in @other_user
      put :accept, id: @transfer.id
      expect(response).to redirect_to root_path
    end
    it 'redirect to my balances on success' do
      sign_in @other_user
      put :accept, id: @transfer.id
      expect(response).to redirect_to my_balances_user_path(@other_user)
    end
    it 'redirects unsigned in to root' do
      put :accept, id: @transfer.id
      expect(response).to redirect_to root_path
    end
  end

  describe 'PUT to reject' do
    before do
      @user = create :user
      @other_user = create :other_user
      @transfer = build(:transfer) do |transfer|
        transfer.from = @user
        transfer.to = @other_user
      end
      @transfer.save!
    end
    it 'redirects to root if user is not the receiver of transfer' do
      sign_in @user
      put :accept, id: @transfer.id
      expect(response).to redirect_to root_path
    end
    it 'redirect to my balances on success' do
      sign_in @other_user
      put :reject, id: @transfer.id
      expect(response).to redirect_to my_balances_user_path(@other_user)
    end
    it 'redirects unsigned in to root' do
      put :reject, id: @transfer.id
      expect(response).to redirect_to root_path
    end
  end
end
