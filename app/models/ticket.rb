class Ticket < ApplicationRecord
  enum :status, { new_ticket: 0, started: 1, completed: 2, resolved: 3 }

  belongs_to :project 
  belongs_to :developer, class_name: 'User', optional: true
  belongs_to :qa, class_name: 'User'
  has_one_attached :screenshot
 
  
  validates :title, presence: true, uniqueness: { scope: :project_id }
  validates :status, presence: true
  validates :type, presence: true
  validates :qa_id, presence: true
  validates :project_id, presence: true
  validate :acceptable_screenshot

  scope :bugs, -> { where(type: 'Bug') }
  scope :features, -> { where(type: 'Feature') }
  private

  def acceptable_screenshot
    return unless screenshot.attached?

    if !screenshot.content_type.in?(%w(image/png image/gif))
      errors.add(:screenshot, 'must be a PNG or GIF image')
    end
  end
end

