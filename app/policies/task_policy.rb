class TaskPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    !@model.completed?
  end

  def destroy?
    true
  end
end
