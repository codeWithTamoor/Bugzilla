class BugPolicy < TicketPolicy
 
  
  def mark_resolved?
    user.present? && user.developer? && record.developer_id == user.id
  end
end