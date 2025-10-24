class Project < ApplicationRecord
  belongs_to :manager, class_name: 'User'
  has_many :user_projects, dependent: :destroy
  has_and_belongs_to_many :users
  has_many :tickets, dependent: :destroy

  # associations for different roles
  has_and_belongs_to_many :developers, -> { where(role: :developer) }, class_name:'User', join_table: 'projects_users'
  has_and_belongs_to_many :qas, -> { where(role: :qa) }, class_name: 'User', join_table:'projects_users'

  validates :name, presence: true, uniqueness: true
  validates :manager_id, presence: true

 
  attr_accessor :developer_ids, :qa_ids

  after_save :assign_users_to_project

  private

  def assign_users_to_project
    # Clear existing users 
    if developer_ids.present? || qa_ids.present?
    developers.clear  
    qas.clear       
    end

    #add
    if developer_ids.present?
    developers_to_add = User.where(id: developer_ids.reject(&:blank?), role: :developer)
    developers.concat(developers_to_add)
    end

  
    if qa_ids.present?
    qas_to_add = User.where(id: qa_ids.reject(&:blank?), role: :qa)
    qas << qas_to_add  
    end
  end
end