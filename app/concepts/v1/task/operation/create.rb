class V1::Task::Operation::Create < Trailblazer::Operation
  step :find_project
  fail :not_found, fail_fast: true

  step Policy::Pundit(TaskPolicy, :create?)
  fail :fail_policy, fail_fast: true

  step :initialize_task
  step :save_task

  fail :add_errors

  def find_project(ctx, current_user:, project_id:, **)
    ctx[:project] = current_user.projects.find_by(id: project_id)
  end

  def not_found(ctx, **)
    ctx[:errors] = ['Not Found']
    ctx[:status] = :not_found
  end

  def fail_policy(ctx, **)
    ctx[:errors] = ['Unauthorized']
    ctx[:status] = :unauthorized
  end

  def initialize_task(ctx, project:, params:, **)
    ctx[:model] = project.tasks.new(params)
  end

  def save_task(_ctx, model:, **)
    model.save
  end

  def add_errors(ctx, model:, **)
    ctx[:errors] = model.errors.full_messages
    ctx[:status] = :unprocessable_entity
  end
end
