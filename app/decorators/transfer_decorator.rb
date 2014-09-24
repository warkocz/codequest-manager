class TransferDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def actions
    (accept_button.to_s + reject_button.to_s).html_safe
  end

  def accept_button
    return unless pending?
    link_to 'Accept', accept_transfer_path(self), data: {confirm: 'Are you sure?'}, method: :put
  end

  def reject_button
    return unless pending?
    link_to 'Reject', reject_transfer_path(self), data: {confirm: 'The transfer will be rejected! Are you sure?'}, method: :put
  end
end