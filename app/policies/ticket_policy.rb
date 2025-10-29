class TicketPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return false unless user.present?
    
    case user
    when Manager
      record.project.manager_id == user.id || user.projects.include?(record.project)
    when Developer
      user.projects.include?(record.project)
    when Qa
      true
    else
      false
    end
  end

  def create?
    return false unless user.present?
    
    
    return true if user.is_a?(Qa)
    #return true if user.is_a?(Manager)
    
    false
  end

  def new?
    create?
  end

  def update?
    return false unless user.present?
    
    case user
    when Manager
      record.project.manager_id == user.id
    when Developer
      user.projects.include?(record.project) && record.developer_id == user.id
    when Qa
      record.qa_id == user.id
    else
      false
    end
  end

  def destroy?
    user.present? && (user.is_a?(Manager) || user.is_a?(Qa))
  end

  def assign_to_self?
    user.present? && user.is_a?(Developer) && user.projects.include?(record.project) && record.developer_id.nil?
  end

  def mark_resolved?
    user.present? && user.is_a?(Developer) && record.developer_id == user.id && record.is_a?(Bug)
  end

  def mark_completed?
    user.present? && user.is_a?(Developer) && record.developer_id == user.id && record.is_a?(Feature)
  end

  class Scope < Scope
  def resolve
    return scope.none unless user.present?

    case user
    when Manager
      managed_project_ids = Project.where(manager_id: user.id).pluck(:id)
      participating_project_ids = user.projects.pluck(:id)
      scope.where(project_id: managed_project_ids + participating_project_ids)

    when Developer
      scope.where(project_id: user.projects.pluck(:id))
    when Qa
      scope.all
    else
      scope.none
    end
  end
end

end