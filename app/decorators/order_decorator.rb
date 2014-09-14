class OrderDecorator < Draper::Decorator
  delegate_all

  def other_dishes(excluded)
    dishes.where.not(user: excluded)
  end

  def user_ordered?(user)
    dishes.find_by(user: user)
  end

  def change_status_link
    if in_progress?
      h.link_to('Mark as ordered', h.change_status_order_path(order), class: 'button', method: :put)
    elsif ordered?
      h.link_to('Mark as delivered', h.change_status_order_path(order), class: 'button', method: :put)
    end
  end

  def ordered_by?(comparison_user)
    user == comparison_user
  end
end