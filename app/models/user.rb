require 'digest/sha2'

class User < ActiveRecord::Base
  has_many :payments, :dependent => :destroy

  validates_presence_of   :email
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of     :email,
                          :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates_presence_of     :password,              :if => :password_required?
  validates_presence_of     :password_confirmation, :if => :password_required?
  validates_confirmation_of :password,              :if => :password_required?

  before_save :hash_password
  before_save :clean_attributes

  attr_accessor :password

  def self.authenticate(email, password)
    find_by_email_and_hashed_password(email.downcase, hash_password(password))
  end

  def self.hash_password(password)
    5.times do
      password = hash_string(password)
    end

    password
  end

  def self.hash_string(string)
    Digest::SHA512.hexdigest("--n839t-#{string}--")
  end

  protected

  def clean_attributes
    email.downcase!
  end

  def hash_password
    if password_required?
      self.hashed_password = self.class.hash_password(password)
    end
  end

  def password_required?
    hashed_password.blank? || !password.blank?
  end
end
