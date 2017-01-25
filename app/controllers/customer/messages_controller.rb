class Customer::MessagesController < Customer::Base
  def new
    @message = CustomerMessage.new
  end

  def confirm
    @message = CustomerMessage.new(customer_message_params)
    if @message.valid?
      render action: 'confirm'
    else
      flash.now.alert = '入力に誤りがあります。'
      render action: 'new'
    end
  end

  private

  def customer_message_params
    params.require(:customer_message).permit(:subject, :body)
  end
end
