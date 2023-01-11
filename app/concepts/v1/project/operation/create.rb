class V1::Project::Operation::Create < Trailblazer::Operation
  step Policy::Pundit(ProjectPolicy, :create?)
  fail :fail_policy, fail_fast: true
  step :find_project
  fail :project_exists, fail_fast: true
  step :initialize_project
  step :save_project

  fail :add_errors

  def find_project(_ctx, params:, current_user:, **)
    model = current_user.projects.find_by(name: params[:name])

    model.nil?
  end

  def project_exists(ctx, **)
    ctx[:errors] = [I18n.t('errors.project_exist')]
    ctx[:status] = :unprocessable_entity
  end

  def initialize_project(ctx, current_user:, params:, **)
    ctx[:model] = current_user.projects.new(name: params[:name])
  end

  def save_project(_ctx, model:, **)
    model.save
  end

  def add_errors(ctx, model:, **)
    ctx[:errors] = model.errors.full_messages
    ctx[:status] = :unprocessable_entity
  end

  def fail_policy(ctx, **)
    ctx[:errors] = ['Unauthorized']
    ctx[:status] = :unauthorized
  end
end
