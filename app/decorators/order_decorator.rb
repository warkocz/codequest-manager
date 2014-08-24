class OrderDecorator < Draper::Decorator
  delegate_all


  def dish_for_user(user)
    dishes.find_by(user: user)
  end

  def other_dishes(excluded)
    dishes.where.not(user: excluded)
  end
end