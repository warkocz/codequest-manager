class UsersController < ApplicationController
  before_action :authenticate_user!
  before_filter :only_current_user, only: [:my_balances]

  def dashboard
    @order = Order.todays_order.try(:decorate)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to dashboard_users_path
    else
      redirect_to edit_user_path(@user)
    end
  end

  def my_balances
    @user = current_user
  end
  private

  def user_params
    params.require(:user).permit(:deposit)
  end

  def find_user
    User.find(params[:id])
  end

  def only_current_user
    return if find_user == current_user
    redirect_to dashboard_users_path, alert: 'You can\' view others balances'
  end

end
