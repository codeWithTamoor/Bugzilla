class Developer < User
  has_many :assigned_tickets, class_name: 'Ticket', foreign_key: 'developer_id'
  belongs_to :manager, class_name: 'Manager', optional: true
end