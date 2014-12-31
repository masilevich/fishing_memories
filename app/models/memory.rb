class Memory < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :occured_at, presence: true

  default_scope -> { order('occured_at DESC') }
end
