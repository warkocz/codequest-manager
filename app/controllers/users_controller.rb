class UsersController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @order = Order.todays_order.try(:decorate)
  end
end
