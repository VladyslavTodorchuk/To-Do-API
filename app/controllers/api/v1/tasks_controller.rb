class Api::V1::TasksController < ApplicationController
  before_action :authorize_access_request!

  def index
    result = V1::Task::Operation::Index.call(params: params, current_user: current_user)

    if result.success?
      render json: V1::TaskSerializer.new(result[:tasks]), status: :found
    else
      render status: :not_found
    end
  end

  def show
    result = V1::Task::Operation::Show.call(project_id: params[:project_id], params: task_params,
                                            current_user: current_user)

    if result.success?
      render json: V1::TaskSerializer.new(result[:model]), status: :found
    else
      render status: :not_found
    end
  end

  def create
    result = V1::Task::Operation::Create.call(project_id: params[:project_id], params: task_params,
                                              current_user: current_user)

    if result.success?
      render json: V1::TaskSerializer.new(result[:model]), status: :created
    else
      render json: { errors: result[:errors] }, status: result[:status]
    end
  end

  def update
    result = V1::Task::Operation::Update.call(project_id: params[:project_id], params: task_params,
                                              current_user: current_user)

    if result.success?
      render json: V1::TaskSerializer.new(result[:model]), status: :ok
    else
      render json: { errors: result[:errors] }, status: result[:status]
    end
  end

  def destroy
    result = V1::Task::Operation::Destroy.call(project_id: params[:project_id], params: task_params,
                                               current_user: current_user)

    if result.success?
      render status: :ok
    else
      render status: :not_found
    end
  end

  private

  def task_params
    params.permit(:id, :title, :position, :deadline, :completed, :project_id, :page)
  end
end
