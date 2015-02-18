class User < ActiveRecord::Base
  has_many :memories, dependent: :destroy
  has_many :tackles, dependent: :destroy
  has_many :tackle_sets, dependent: :destroy
  has_many :ponds, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :tackle_categories
  has_many :tackle_set_categories
  has_many :pond_categories

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
  uniqueness: {case_sensitive:false}

  valid_user_name = Regexp.new(/\A/.source + ApplicationHelper::USER_NAME_REGEX.source + /\z/.source, Regexp::IGNORECASE)
  validates :username, uniqueness: {case_sensitive: false},
  format: {with: valid_user_name}, length: {maximum: 20} 

  devise :confirmable, :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end