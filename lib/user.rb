class User < ActiveRecord::Base
  has_many :accounts
  has_many :services, :through => :accounts
  default_scope order('name')
end
