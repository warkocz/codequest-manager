class OrderDecorator < Draper::Decorator
  include Draper::LazyHelpers
  
  delegate_all

  DELIVER_TEXT = 'Did you remember to add shipping cost?'

  def current_user_ordered?
    dishes.find_by(user: current_user)
  end

  def change_status_link
    link = ''
    if in_progress?
      link += link_to('Mark as ordered', change_status_order_path(order), class: 'button', method: :put)
    elsif ordered?
      link += link_to('Mark as delivered', change_status_order_path(order), class: 'button', method: :put, data: {confirm: DELIVER_TEXT})
    end
    link
  end

  def ordered_by_current_user?
    user == current_user
  end

  def summary_buttons
    buttons = ''
    unless order.delivered?
      buttons += link_to 'Change payer', edit_order_path(object), class: 'button'
    end
    if order.ordered? && ordered_by_current_user?
      buttons += link_to 'Add shipping', shipping_order_path(object), class:'button'
    end
    if ordered_by_current_user?
      buttons += change_status_link
    end
    buttons.html_safe
  end
end