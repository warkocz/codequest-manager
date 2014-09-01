class UsersController < ApplicationController
  before_action :authenticate_user!

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

  private

  def user_params
    params.require(:user).permit(:deposit)
  end

end
