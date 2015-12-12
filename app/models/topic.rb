class Topic < ActiveRecord::Base
  has_many :knowledges
  has_many :experts, through: :knowledges

  validates :name, uniqueness: true
  validates :name, presence: true
end
