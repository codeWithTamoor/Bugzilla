class Manager < User
  has_many :subordinates, class_name: 'User', foreign_key: 'manager_id'
  has_many :created_projects, class_name: 'Project', foreign_key: 'manager_id'
end