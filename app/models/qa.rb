class Qa < User
  has_many :reported_tickets, class_name: 'Ticket', foreign_key: 'qa_id'
  belongs_to :manager, class_name: 'Manager', optional: true
end