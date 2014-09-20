class DishDecorator < Draper::Decorator
  include Draper::LazyHelpers
  
  delegate_all

  def belongs_to_current_user?
    object.user == current_user
  end

  def table_buttons
    (edit_button.to_s + delete_button.to_s + copy_button.to_s).html_safe
  end

  def edit_button
    if belongs_to_current_user? && !order.delivered?
      link_to 'Edit', edit_order_dish_path(order, object), class: 'margin-right-small'
    end
  end

  def delete_button
    if belongs_to_current_user? && order.in_progress?
      link_to 'Delete', order_dish_path(order, object), data: {confirm: 'Are you sure?'}, method: :delete
    end
  end

  def copy_button
    if !belongs_to_current_user? && order.in_progress?
      link_to 'Copy', copy_order_dish_path(order, object), data: {confirm: 'This will overwrite your current dish! Are you sure?'}
    end
  end
end