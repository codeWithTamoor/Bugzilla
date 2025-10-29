class Project < ApplicationRecord
  belongs_to :manager, class_name: 'User'
  
  has_and_belongs_to_many :users
  has_many :tickets, dependent: :destroy

  has_and_belongs_to_many :developers, -> { where(type: 'Developer') }, class_name: 'User', join_table: 'projects_users'
  has_and_belongs_to_many :qas,-> { where(type: 'Qa') },  class_name: 'User',  join_table: 'projects_users'
  validates :name, presence: true, uniqueness: true
  validates :manager_id, presence: true

  def developer_ids=(ids)
    ids = ids.reject(&:blank?)
    self.developers = Developer.where(id: ids)
  end

  def qa_ids=(ids)
    ids = ids.reject(&:blank?)
    self.qas = Qa.where(id: ids)
  end
end


