class Memory < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :occured_at, presence: true

  default_scope -> { order('occured_at DESC') }

  def title
  	"#{Memory.model_name.human} #{I18n.t('date.from')} #{occured_at}"
  end
end
