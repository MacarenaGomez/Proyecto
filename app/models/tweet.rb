class Tweet < ActiveRecord::Base
  belongs_to :expert
  has_many :resources
end
