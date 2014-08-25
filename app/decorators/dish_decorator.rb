class DishDecorator < Draper::Decorator
  delegate_all

  def belongs_to?(user)
    object.user == user
  end
end