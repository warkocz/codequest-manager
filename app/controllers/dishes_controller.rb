class DishesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_order

  def new
    @dish = @order.dishes.build
  end

  def create
    if @order.dishes.create(dish_params)
      redirect_to users_dashboard_path
    else
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
      render :edit
    end
  end

  private

  def find_order
    @order = Order.find(params[:order_id])
  end

  def dish_params
    params.require(:dish).permit(:user_id, :name, :price)
  end
end