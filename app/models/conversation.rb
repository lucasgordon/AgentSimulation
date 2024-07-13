class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :agents, through: :messages
end
