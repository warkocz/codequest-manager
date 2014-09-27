class DishesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_order
  before_filter :find_dish, only: [:copy, :destroy, :edit]

  def new
    @dish = @order.dishes.build
  end

  def create
    @dish = @order.dishes.build(dish_params)
    if @dish.save
      redirect_to dashboard_users_path
    else
      flash.now[:alert] = @dish.errors.full_messages.join(' ')
      render :new
    end
  end

  def edit
  end

  def update
    @dish = Dish.find params[:id]
    if @dish.update(dish_params)
      redirect_to dashboard_users_path
    else
      flash.now[:alert] = @dish.errors.full_messages.join(' ')
      render :edit
    end
  end

  def destroy
    @dish.delete
    redirect_to dashboard_users_path
  end

  def copy
    @new_dish = @dish.copy(current_user)
    if @new_dish.save
      redirect_to dashboard_users_path
    else
      redirect_to dashboard_users_path, alert: @new_dish.errors.full_messages.join(' ')
    end
  end

  private

  def find_order
    @order = Order.find(params[:order_id])
  end

  def find_dish
    @dish = @order.dishes.find(params[:id])
  end

  def dish_params
    params.require(:dish).permit(:user_id, :name, :price)
  end
end