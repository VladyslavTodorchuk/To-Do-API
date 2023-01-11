class V1::Project::Operation::Show < Trailblazer::Operation
  step :find_project
  fail :add_errors, fail_fast: true

  def find_project(ctx, params:, current_user:, **)
    ctx[:model] = current_user.projects.find_by(id: params[:id])
  end

  def add_errors(ctx, **)
    ctx[:status] = :not_found
  end
end
