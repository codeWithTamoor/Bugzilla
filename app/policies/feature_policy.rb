class FeaturePolicy < TicketPolicy
 
  def mark_completed?
    user.present? && user.developer? && record.developer_id == user.id
  end
end