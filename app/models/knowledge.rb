class Knowledge < ActiveRecord::Base
  belongs_to :expert
  belongs_to :topic
end
