class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { manager: 1, developer: 2, qa: 3 }

  # Associations
  has_many :created_projects, class_name: 'Project', foreign_key: 'manager_id'
  has_many :user_projects
  has_many :projects, through: :user_projects
  
  # Tickets where user is developer
  has_many :assigned_tickets, class_name: 'Ticket', foreign_key: 'developer_id'
  
  # Tickets where user is QA/reporter
  has_many :reported_tickets, class_name: 'Ticket', foreign_key: 'qa_id'
  
  # Manager-subordinate relationship
  belongs_to :manager, class_name: 'User', optional: true
  has_many :subordinates, class_name: 'User', foreign_key: 'manager_id'

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end