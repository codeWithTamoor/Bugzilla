class ProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    case user
    when Manager
      record.manager_id == user.id || user.projects.include?(record)
    when Developer
      user.projects.include?(record)
    when Qa
      true
    else
      false
    end
  end

  def create?
    user.is_a?(Manager)
  end

  def update?
    user.is_a?(Manager) && record.manager_id == user.id
  end

  def destroy?
    user.is_a?(Manager) && record.manager_id == user.id
  end

  def add_remove_users?
    user.is_a?(Manager) && record.manager_id == user.id
  end


  class Scope < Scope
    def resolve
      case user
      when Manager
        scope.where(manager_id: user.id).or(scope.where(id: user.projects))
      when Developer
        user.projects
      when Qa
        scope.all
      else
        scope.none
      end
    end
  end
end