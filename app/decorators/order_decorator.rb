class OrderDecorator < Draper::Decorator
  delegate_all

  def other_dishes(excluded)
    dishes.where.not(user: excluded)
  end

  def user_ordered?(user)
    dishes.find_by(user: user)
  end
end