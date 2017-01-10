class Admin::StaffEventsController < Admin::Base
  def index
    if params[:staff_member_id]
      @staff_member = StaffMember.find(params[:staff_member_id])
      @events = @staff_member.events
    else
      @events = StaffEvent.includes(:member)
    end
    @events = @events.order(occurred_at: :desc).page(params[:page])
  end
end
