json.data do
  json.tasks do
    json.call(
      @tasks,
      :id,
      :title,
      :completed,
      :position,
      :created_at,
      :updated_at
    )
  end
end
