class Expert < ActiveRecord::Base
  has_many :tweets
  has_many :knowledges
  has_many :topics, through: :knowledges

  validates :name, uniqueness: true
  validates :name, presence: true
  validates :twitter, presence: true
  validates :twitter, uniqueness: true
  validates :linkedin, presence: true
  validates :linkedin, uniqueness: true
end
