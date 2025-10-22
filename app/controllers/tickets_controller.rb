class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :assign_to_self, :mark_resolved, :mark_completed]

  def index
    @tickets = policy_scope(Ticket)
    @bugs = @tickets.bugs
    @features = @tickets.features
  end

  def show
    authorize @ticket
  end

  def new
    @ticket = Ticket.new
    authorize @ticket
    set_form_data
  end

  def create
    @ticket = build_ticket_from_type
    @ticket.qa = current_user
    authorize @ticket

    if @ticket.save
      redirect_to @ticket, notice: 'Ticket was successfully created.'
    else
      set_form_data
      render :new
    end
  end

  def update
    authorize @ticket
    if @ticket.update(ticket_params)
      redirect_to @ticket, notice: 'Ticket was successfully updated.'
    else
      set_form_data
      render :edit
    end
  end

  def destroy
    authorize @ticket
    @ticket.destroy
    redirect_to tickets_url, notice: 'Ticket was successfully destroyed.'
  end

  def assign_to_self
    authorize @ticket, :assign_to_self?
    @ticket.update(developer: current_user, status: 'started')
    redirect_to @ticket, notice: 'Ticket assigned to you.'
  end

  def mark_resolved
    authorize @ticket, :mark_resolved?
    @ticket.update(status: 'resolved')
    redirect_to @ticket, notice: 'Bug marked as resolved.'
  end

  def mark_completed
    authorize @ticket, :mark_completed?
    @ticket.update(status: 'completed')
    redirect_to @ticket, notice: 'Feature marked as completed.'
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def build_ticket_from_type
    type = params[:ticket][:type]
    if type == 'Bug'
      Bug.new(ticket_params)
    else
      Feature.new(ticket_params)
    end
  end

  def ticket_params
    params.require(:ticket).permit(:title, :type, :status, :developer_id, :project_id, :screenshot, :description, :deadline)
  end

  def set_form_data
    @projects = current_user.qa? ? Project.all : current_user.projects
    @developers = User.developer
  end
end