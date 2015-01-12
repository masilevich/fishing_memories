class Tackle < ActiveRecord::Base
	belongs_to :user

  validates :user_id, presence: true
  validates :name, presence: true

  default_scope -> { order('name ASC') }

  def title
  	name
  end
end
