class ConversationAgent < ApplicationRecord
  belongs_to :conversation
  belongs_to :agent
end
