class Message < ApplicationRecord
  belongs_to :agent
  belongs_to :conversation
end
