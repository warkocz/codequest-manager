class TransfersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user

  def new
    @transfer = @user.submitted_transfers.build
  end

  def create
    @transfer = @user.received_transfers.build transfer_params
    @transfer.from = current_user
    if @transfer.save
      redirect_to my_balances_user_path(current_user), notice: 'Transfer successfully submitted'
    else
      redirect_to new_user_transfer_path(@user), alert: @transfer.errors.full_messages.join(' ')
    end
  end

  private

  def transfer_params
    params.require(:transfer).permit(:amount)
  end

  def find_user
    @user = User.find(params[:user_id])
  end
end