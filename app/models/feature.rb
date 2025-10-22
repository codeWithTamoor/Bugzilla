class Feature < Ticket
  # Feature-specific validations
  validate :feature_status_valid
  
  private
  
  def feature_status_valid
    unless ['new_ticket', 'started', 'completed'].include?(status)
      errors.add(:status, "for feature must be new, started, or completed")
    end
  end
end