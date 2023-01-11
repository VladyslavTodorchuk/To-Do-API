class V1::Task::Operation::Show < Trailblazer::Operation
  step :find_task

  def find_task(ctx, params:, **)
    ctx[:model] = Task.find_by(id: params[:id])
  end
end
