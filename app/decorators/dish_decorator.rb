class DishDecorator < Draper::Decorator
  delegate_all

  def belongs_to?(user)
    object.user == user
  end

  def table_buttons(current_user)
    return if object.order.delivered?
    buttons = ''
    if belongs_to?(current_user) && !order.delivered?
      buttons += h.link_to 'Edit', h.edit_order_dish_path(order, object), class: 'margin-right-small'
    end
    if belongs_to?(current_user) && order.in_progress?
      buttons += h.link_to 'Delete', h.order_dish_path(order, object), data: {confirm: 'Are you sure?'}, method: :delete
    elsif order.in_progress?
      buttons += h.link_to 'Copy', h.copy_order_dish_path(order, object), data: {confirm: 'This will overwrite your current dish! Are you sure?'}
    end
    buttons.html_safe
  end
end