class Expert < ActiveRecord::Base
  has_many :tweets
  has_many :profiles
  has_many :knowledges
  has_many :topics, through: :knowledges

  validates :name, presence: true
end
