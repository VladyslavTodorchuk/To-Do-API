class V1::Project::Operation::Index < Trailblazer::Operation
  step :get_all_project

  def get_all_project(ctx, current_user:, params:, **)
    ctx[:models] = current_user.projects.page(params[:page])
  end
end
