class User < ActiveRecord::Base
  has_many :memories, dependent: :destroy
  has_many :tackles, dependent: :destroy
  has_many :tackle_sets, dependent: :destroy
  has_many :ponds, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :tackle_categories
  has_many :tackle_set_categories
  has_many :pond_categories

  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
  uniqueness: {case_sensitive:false}

  validates :username, uniqueness: {case_sensitive: false},
  format: {with: VALID_USER_NAME_REGEX }, length: {maximum: 20} 

  devise :confirmable, :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :login

  enum role: [:admin]

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def title
    username
  end
end