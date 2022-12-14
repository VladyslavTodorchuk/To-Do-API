class V1::Task::Operation::Create < Trailblazer::Operation
  step :find_project,
       Output(Trailblazer::Activity::Left, :failure) => Path(end_id: 'End.failure', end_task: End(:with_failure)) do
    step :not_found
  end
  step :initialize_task
  step :save_task

  fail :add_errors

  def find_project(ctx, current_user:, project_id:, **)
    ctx[:project] = current_user.projects.find_by(id: project_id)
  end

  def initialize_task(ctx, project:, params:, **)
    ctx[:task] = project.tasks.new(params)
  end

  def save_task(_ctx, task:, **)
    task.save
  end

  def add_errors(ctx, task:, **)
    ctx[:errors] = task.errors.full_messages
    ctx[:status] = :unprocessable_entity
  end

  def not_found(ctx, **)
    ctx[:errors] = ['Not Found']
    ctx[:status] = :not_found
  end
end
