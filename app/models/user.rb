class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { manager: 1, developer: 2, qa: 3 }
  has_many :created_projects, class_name: 'Project', foreign_key: 'manager_id'
  #has_and :user_projects
  has_and_belongs_to_many :projects
  #developer can assign ticket ti him
  has_many :assigned_tickets, class_name: 'Ticket', foreign_key: 'developer_id'
  # can repoert the tickets QA
  has_many :reported_tickets, class_name: 'Ticket', foreign_key: 'qa_id'
  belongs_to :manager, class_name: 'User', optional: true
  has_many :subordinates, class_name: 'User', foreign_key: 'manager_id'

  #validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end