class Bug < Ticket
  # Bug-specific validations
  validate :bug_status_valid
  
  private
  
  def bug_status_valid
    unless ['new_ticket', 'started', 'resolved'].include?(status)
      errors.add(:status, "for bug must be new, started, or resolved")
    end
  end
end