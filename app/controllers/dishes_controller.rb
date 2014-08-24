class DishesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_order

  def new
    @dish = @order.dishes.build
  end

  def create
    @dish = @order.dishes.build(dish_params)
    if @dish.save
      redirect_to users_dashboard_path
    else
      flash.now[:alert] = @dish.errors.full_messages.join(' ')
      render :new
    end
  end

  def edit
    @dish = Dish.find params[:id]
  end

  def update
    @dish = Dish.find params[:id]
    if @dish.update(dish_params)
      redirect_to users_dashboard_path
    else
      flash.now[:alert] = @dish.errors.full_messages.join(' ')
      render :edit
    end
  end

  def destroy
    @dish = Dish.find params[:id]
    @dish.delete
    redirect_to users_dashboard_path
  end

  private

  def find_order
    @order = Order.find(params[:order_id])
  end

  def dish_params
    params.require(:dish).permit(:user_id, :name, :price)
  end
end