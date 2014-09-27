class TransfersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user, only: [:new, :create]
  before_filter :find_transfer, except: [:new, :create]

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

  def accept
    if current_user == @transfer.to && @transfer.pending?
      @transfer.mark_as_accepted!
      redirect_to my_balances_user_path(current_user)
    else
      wrong_user!
    end
  end

  def reject
    if current_user == @transfer.to && @transfer.pending?
      @transfer.rejected!
      redirect_to my_balances_user_path(current_user)
    else
      wrong_user!
    end
  end

  private

  def transfer_params
    params.require(:transfer).permit(:amount)
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_transfer
    @transfer = Transfer.find(params[:id])
  end

  def wrong_user!
    redirect_to root_path
  end
end