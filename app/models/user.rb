class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable
  
  # has_many :searches
  # has_many :topics, through: :searches

  # validates  :name, presence: true
  # validates  :email, presence: true

end
