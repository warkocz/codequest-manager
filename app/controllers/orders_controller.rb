class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :assign_users, only: [:edit, :new]

  def new
    @order = Order.new
  end

  def create
    @order = Order.new order_params
    if @order.save
      redirect_to users_dashboard_path
    else
      render :new
    end
  end

  def edit
    @order = Order.find params[:id]
  end

  def update
    @order = Order.find params[:id]
    if @order.update(order_params)
      redirect_to users_dashboard_path
    else
      render :edit
    end
  end

  def assign_users
    @users = User.all.map do |user|
      [user.name, user.id]
    end
  end

  private

  def order_params
    params.require(:order).permit(:orderer_id).merge(date: Date.today)
  end
end
