class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true,
                  format: { with: /\S+@\S+/ },
                  uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 8, allow_blank: true }

  has_many :conversations
  has_many :agents

end
