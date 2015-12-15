class Topic < ActiveRecord::Base
  has_many :knowledges
  has_many :experts, through: :knowledges
  has_many :searches
  has_many :users, through: :searches

  validates :name, uniqueness: true
  validates :name, presence: true
end
