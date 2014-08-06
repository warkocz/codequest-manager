class UsersController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @order = Order.todays_order
  end
end
