class V1::Project::Operation::Destroy < Trailblazer::Operation
  step :find_project
  fail :not_found, fail_fast: true

  step Policy::Pundit(ProjectPolicy, :destroy?)
  fail :fail_policy, fail_fast: true

  step :destroy_project
  fail :add_errors

  def fail_policy(ctx, **)
    ctx[:errors] = ['Unauthorized']
    ctx[:status] = :unauthorized
  end

  def find_project(ctx, params:, current_user:, **)
    ctx[:model] = current_user.projects.find_by(id: params[:id])
  end

  def not_found(ctx, **)
    ctx[:errors] = [I18n.t('errors.not_found')]
    ctx[:status] = :not_found
  end

  def destroy_project(_ctx, model:, **)
    model.destroy
  end

  def add_errors(ctx, **)
    ctx[:status] = :unprocessable_entity
  end
end
