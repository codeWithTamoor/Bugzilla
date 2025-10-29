class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :add_user, :remove_user]
  before_action :set_available_users, only: [:new, :edit, :create, :update, :show]
  before_action :authenticate_user!

  def index
    @projects = policy_scope(Project)
  end

   def show
    authorize @project
    @developers = @project.developers
    @qas = @project.qas
  end

  def new
    @project = Project.new
    @project.manager = current_user
    @project.developer_ids = []
    @project.qa_ids = []
    authorize @project
  end

  def edit
    authorize @project
    @project.developer_ids = @project.developers.pluck(:id)
    @project.qa_ids = @project.qas.pluck(:id)
  end

  def create
    @project = Project.new(project_params)
    @project.manager = current_user
    authorize @project

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @project
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      set_available_users
      render :edit
    end
  end

  def destroy
    authorize @project
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  def add_user
    authorize @project, :add_remove_users?
    user = User.find(params[:user_id])
    unless @project.users.exists?(user.id)
      @project.users << user
      notice = "#{user.name} added to project."
    else
      notice = "#{user.name} is already part of this project."
    end
    redirect_to @project, notice: notice
  end

  def remove_user
    authorize @project, :add_remove_users?
    user = User.find(params[:user_id])
    if @project.users.delete(user)
      redirect_to @project, notice: "#{user.name} removed from project."
    else
      redirect_to @project, alert: "Failed to remove user."
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def set_available_users
    @available_developers = Developer.all
    @available_qas = Qa.all
  end

  def project_params
    params.require(:project).permit(:name, :desc, developer_ids: [], qa_ids: [])
  end
end