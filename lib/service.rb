class Service < ActiveRecord::Base
  has_many :accounts
  has_many :users, :through => :accounts
  default_scope { order('name') }
end
