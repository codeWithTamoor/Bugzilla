class ProjectPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    case user.role
    when 'manager'
      record.manager_id == user.id || user.projects.include?(record)
    when 'developer'
      user.projects.include?(record)
    when 'qa'
      true
    else
      false
    end
  end

  def create?
    user.manager?
  end

  def update?
    user.manager? && record.manager_id == user.id
  end

  def destroy?
    user.manager? && record.manager_id == user.id
  end

  def add_remove_users?
    user.manager? && record.manager_id == user.id
  end


  class Scope < Scope
    def resolve
      case user.role
      when 'manager'
        scope.where(manager_id: user.id).or(scope.where(id: user.projects))
      when 'developer'
        user.projects
      when 'qa'
        scope.all
      else
        scope.none
      end
    end
  end
end