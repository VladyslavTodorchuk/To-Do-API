class V1::Comment::Operation::Destroy < Trailblazer::Operation
  step :find_comment
  step Policy::Pundit(CommentPolicy, :destroy?)
  fail :fail_policy, fail_fast: true

  step :destroy_comment

  fail :add_errors

  def find_comment(ctx, params:, **)
    ctx[:model] = Comment.find_by(id: params[:id])
  end

  def fail_policy(ctx, **)
    ctx[:errors] = ['Unauthorized']
    ctx[:status] = :unauthorized
  end

  def destroy_comment(_ctx, model:, **)
    model.destroy
  end

  def add_errors(ctx, **)
    ctx[:errors] = ['Not Found']
    ctx[:status] = :not_found
  end
end
