class Project < ApplicationRecord
  belongs_to :manager, class_name: 'User'
  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects
  has_many :tickets, dependent: :destroy

  # Convenience associations for different roles
  has_many :developers, -> { where(role: :developer) }, through: :user_projects, source: :user
  has_many :qas, -> { where(role: :qa) }, through: :user_projects, source: :user

  validates :name, presence: true, uniqueness: true
  validates :manager_id, presence: true

  # Virtual attributes for form
  attr_accessor :developer_ids, :qa_ids

  after_save :assign_users_to_project

  private

  def assign_users_to_project
    # Clear existing users first if we're updating
    users.clear if developer_ids.present? || qa_ids.present?

    # Add developers
    if developer_ids.present?
      developers_to_add = User.where(id: developer_ids.reject(&:blank?), role: :developer)
      users << developers_to_add
    end

    # Add QAs
    if qa_ids.present?
      qas_to_add = User.where(id: qa_ids.reject(&:blank?), role: :qa)
      users << qas_to_add
    end
  end
end