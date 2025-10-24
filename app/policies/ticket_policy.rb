class TicketPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return false unless user.present?
    
    case user.role
    when 'manager'
      record.project.manager_id == user.id || user.projects.include?(record.project)
    when 'developer'
      user.projects.include?(record.project)
    when 'qa'
      true
    else
      false
    end
  end

  def create?
    return false unless user.present?
    
    # QA can always create tickets
    return true if user.qa?
    
    # Managers can create tickets (project validation will happen in form)
    return true if user.manager?
    
    false
  end

  def new?
    create?
  end

  def update?
    return false unless user.present?
    
    case user.role
    when 'manager'
      record.project.manager_id == user.id
    when 'developer'
      user.projects.include?(record.project) && record.developer_id == user.id
    when 'qa'
      record.qa_id == user.id
    else
      false
    end
  end

  def destroy?
    user.present? && user.manager? && record.project.manager_id == user.id
  end

  def assign_to_self?
    user.present? && user.developer? && user.projects.include?(record.project) && record.developer_id.nil?
  end

  def mark_resolved?
    user.present? && user.developer? && record.developer_id == user.id && record.is_a?(Bug)
  end

  def mark_completed?
    user.present? && user.developer? && record.developer_id == user.id && record.is_a?(Feature)
  end

  class Scope < Scope
    def resolve
      return scope.none unless user.present?
      
      case user.role
      when 'manager'
        scope.joins(:project).where(projects: { manager_id: user.id }).or(scope.where(project_id: user.projects))
      when 'developer'
        scope.where(project_id: user.projects)
      when 'qa'
        scope.all
      else
        scope.none
      end
    end
  end
end