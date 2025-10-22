class Ticket < ApplicationRecord
  # STI configuration
  self.inheritance_column = :type
  
  # Enums
  enum :status, { new_ticket: 0, started: 1, completed: 2, resolved: 3 }

  # Associations
  belongs_to :project
  belongs_to :developer, class_name: 'User', optional: true
  belongs_to :qa, class_name: 'User'
  
  # Validations
  validates :title, presence: true, uniqueness: { scope: :project_id }
  validates :status, presence: true
  validates :type, presence: true
  validates :qa_id, presence: true
  validates :project_id, presence: true

  

  # Scopes
  scope :bugs, -> { where(type: 'Bug') }
  scope :features, -> { where(type: 'Feature') }
end