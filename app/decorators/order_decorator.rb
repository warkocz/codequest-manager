class OrderDecorator < Draper::Decorator
  delegate_all

  def other_dishes(excluded)
    dishes.where.not(user: excluded)
  end

  def user_ordered?(user)
    dishes.find_by(user: user)
  end

  def change_status_link
    link = ''
    if in_progress?
      link += h.link_to('Mark as ordered', h.change_status_order_path(order), class: 'button', method: :put)
    elsif ordered?
      link += h.link_to('Mark as delivered', h.change_status_order_path(order), class: 'button', method: :put)
    end
    link
  end

  def ordered_by?(comparison_user)
    user == comparison_user
  end

  def summary_buttons(user)
    buttons = ''
    unless order.delivered?
      buttons += h.link_to 'Change payer', h.edit_order_path(object), class: 'button'
    end
    if ordered_by?(user)
      buttons += change_status_link
    end
    buttons.html_safe
  end
end