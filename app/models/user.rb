class User < ApplicationRecord
  self.inheritance_column = 'type'  

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_and_belongs_to_many :projects
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  scope :developers, -> { where(type: 'Developer') }
  scope :qas, -> { where(type: 'Qa') }
  scope :managers, -> { where(type: 'Manager') }
end