class Admin::TopController < Admin::Base
  skip_before_action :authorize

  def index
    if current_administrator
      render action: :dashboard
    end
  end
end
