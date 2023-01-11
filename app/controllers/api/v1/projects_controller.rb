class Api::V1::ProjectsController < ApplicationController
  before_action :authorize_access_request!
  def index
    result = V1::Project::Operation::Index.call(current_user: current_user, params: params)

    if result.success?
      render json: V1::ProjectSerializer.new(result[:models]), status: :found
    else
      render status: result[:status]
    end
  end

  def show
    result = V1::Project::Operation::Show.call(current_user: current_user, params: params)

    if result.success?
      render json: V1::ProjectSerializer.new(result[:model]), status: :found
    else
      render status: result[:status]
    end
  end

  def create
    result = V1::Project::Operation::Create.call(current_user: current_user, params: params)

    if result.success?
      render json: V1::ProjectSerializer.new(result[:model]), status: :created
    else
      render json: { errors: result[:errors] }, status: result[:status]
    end
  end

  def update
    result = V1::Project::Operation::Update.call(current_user: current_user, params: params)

    if result.success?
      render json: V1::ProjectSerializer.new(result[:model]), status: :ok
    else
      render json: { errors: result[:errors] }, status: result[:status]
    end
  end

  def destroy
    result = V1::Project::Operation::Destroy.call(current_user: current_user, params: params)

    if result.success?
      render status: :ok
    else
      render status: result[:status]
    end
  end
end
