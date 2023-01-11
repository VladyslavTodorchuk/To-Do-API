class Api::V1::CommentsController < ApplicationController
  before_action :authorize_access_request!

  def index
    result = V1::Comment::Operation::Index.call(params: params, current_user: current_user)

    if result.success?
      render json: V1::CommentSerializer.new(result[:comments]), status: :found
    else
      render status: :not_found
    end
  end

  def show
    result = V1::Comment::Operation::Show.call(params: params, current_user: current_user)

    if result.success?
      render json: V1::CommentSerializer.new(result[:model]), status: :found
    else
      render status: :not_found
    end
  end

  def create
    result = V1::Comment::Operation::Create.call(params: params, comment_params: comment_params,
                                                 current_user: current_user)

    if result.success?
      render json: V1::CommentSerializer.new(result[:model]), status: :created
    else
      render json: { errors: result[:errors] }, status: result[:status]
    end
  end

  def destroy
    result = V1::Comment::Operation::Destroy.call(params: params, current_user: current_user)

    if result.success?
      render status: :ok
    else
      render status: :not_found
    end
  end

  private

  def comment_params
    params.permit(:body, :image, :page)
  end
end
