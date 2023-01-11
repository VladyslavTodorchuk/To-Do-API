class V1::Project::Operation::Update < Trailblazer::Operation
  step :find_project
  fail :not_found, fail_fast: true

  step Policy::Pundit(ProjectPolicy, :update?)
  fail :fail_policy, fail_fast: true

  step :update_project
  fail :add_errors

  def find_project(ctx, params:, current_user:, **)
    ctx[:model] = current_user.projects.find_by(id: params[:id])
  end

  def not_found(ctx, **)
    ctx[:errors] = [I18n.t('errors.not_found')]
    ctx[:status] = :not_found
  end

  def fail_policy(ctx, **)
    ctx[:errors] = ['Unauthorized']
    ctx[:status] = :unauthorized
  end

  def update_project(_ctx, params:, model:, **)
    model.update(name: params[:name])
  end

  def add_errors(ctx, model:, **)
    ctx[:errors] = model.errors.full_messages
    ctx[:status] = :unprocessable_entity
  end
end
