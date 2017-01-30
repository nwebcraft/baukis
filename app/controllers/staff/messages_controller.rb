class Staff::MessagesController < Staff::Base
  before_action :reject_non_xhr, only: [:count]

  def count
    render text: CustomerMessage.unprocessed.count
  end
end
