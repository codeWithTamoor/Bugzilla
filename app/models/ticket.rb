class Ticket < ApplicationRecord
  # STI
  self.inheritance_column = :type
  
  
  enum :status, { new_ticket: 0, started: 1, completed: 2, resolved: 3 }

  # associate
  belongs_to :project
  belongs_to :developer, class_name: 'User', optional: true
  belongs_to :qa, class_name: 'User'
  
  # necessary validation
  validates :title, presence: true, uniqueness: { scope: :project_id }
  validates :status, presence: true
  validates :type, presence: true
  validates :qa_id, presence: true
  validates :project_id, presence: true

  scope :bugs, -> { where(type: 'Bug') }
  scope :features, -> { where(type: 'Feature') }
end