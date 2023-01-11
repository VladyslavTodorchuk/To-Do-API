class V1::Task::Operation::Destroy < Trailblazer::Operation
  step :find_task

  step Policy::Pundit(TaskPolicy, :destroy?)
  fail :fail_policy, fail_fast: true

  step :destroy_task

  def find_task(ctx, params:, **)
    ctx[:model] = Task.find_by(id: params[:id])
  end

  def fail_policy(ctx, **)
    ctx[:errors] = ['Unauthorized']
    ctx[:status] = :unauthorized
  end

  def destroy_task(_ctx, model:, **)
    model.destroy
  end
end
