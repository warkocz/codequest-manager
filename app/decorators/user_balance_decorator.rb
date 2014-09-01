class UserBalanceDecorator < Draper::Decorator
  delegate_all

  def to_s
    object.balance.to_s
  end
end