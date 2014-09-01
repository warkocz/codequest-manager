class OrdersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :assign_users, only: [:edit, :new]

  def new
    @order = Order.new
  end

  def create
    @order = Order.new order_params.merge(date: Date.today)
    if @order.save
      redirect_to dashboard_users_path
    else
      redirect_to new_order_path, alert: @order.errors.full_messages.join(' ')
    end
  end

  def edit
    @order = Order.find params[:id]
  end

  def update
    @order = Order.find params[:id]
    if @order.update(order_params)
      redirect_to dashboard_users_path
    else
      redirect_to edit_order_path(@order), alert: @order.errors.full_messages.join(' ')
    end
  end

  def assign_users
    @users = User.all.map do |user|
      [user.name, user.id]
    end
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :from)
  end
end
