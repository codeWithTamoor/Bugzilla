class BugPolicy < TicketPolicy
 
  
  def mark_resolved?
    user.present? && user.is_a?(Developer) && record.developer_id == user.id
  end
end