class Profile < ActiveRecord::Base
  belongs_to :expert

  validates :url, uniqueness: true
  validates :profile_type, presence: true
end
