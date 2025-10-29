class FeaturePolicy < TicketPolicy
 
  def mark_completed?
    user.present? && user.is_a?(Developer) && record.developer_id == user.id
  end
end