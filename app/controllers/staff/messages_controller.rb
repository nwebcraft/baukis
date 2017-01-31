class Staff::MessagesController < Staff::Base
  before_action :reject_non_xhr, only: [:count]

  def index
    @messages = Message.where(deleted: false).page(params[:page])
  end

  def inbound
    @messages = CustomerMessage.where(deleted: false).page(params[:page])
    render action: 'index'
  end

  def outbound
    @messages = StaffMessage.where(deleted: false).page(params[:page])
    render action: 'index'
  end

  def deleted
    @messages = Message.where(deleted: true).page(params[:page])
    render action: 'index'
  end

  def count
    render text: CustomerMessage.unprocessed.count
  end

  def destroy
    message = CustomerMessage.find(params[:id])
    message.update_column(:deleted, true)
    flash.notice = '問い合わせを削除しました。'
    redirect_to :back
  end
end
