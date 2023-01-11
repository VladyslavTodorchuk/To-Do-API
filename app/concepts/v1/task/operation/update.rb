class V1::Task::Operation::Update < Trailblazer::Operation
  step :find_task
  fail :not_found, fail_fast: true

  step Policy::Pundit(TaskPolicy, :update?)
  fail :fail_policy, fail_fast: true

  step :update_task
  fail :add_errors

  def find_task(ctx, params:, **)
    ctx[:model] = Task.find_by(id: params[:id])
  end

  def not_found(ctx, **)
    ctx[:errors] = [I18n.t('errors.not_found')]
    ctx[:status] = :not_found
  end

  def fail_policy(ctx, **)
    ctx[:errors] = ['Unauthorized']
    ctx[:status] = :unauthorized
  end

  def update_task(_ctx, model:, params:, **)
    model.update(params)
  end

  def add_errors(ctx, model:, **)
    ctx[:errors] = model.errors.full_messages
    ctx[:status] = :unprocessable_entity
  end
end
