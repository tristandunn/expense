require "digest/sha2"

class User < ActiveRecord::Base
  has_many :payments, dependent: :destroy

  has_secure_password

  validates_presence_of   :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of     :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  before_save :clean_attributes

  protected

  def clean_attributes
    email.downcase!
  end
end
