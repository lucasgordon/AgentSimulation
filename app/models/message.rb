class Message < ApplicationRecord
  belongs_to :agent
  belongs_to :conversation

  def generate_message
    # This is a placeholder for the actual message generation logic
    # This will be implemented in the future
    self.update!(message_text: "This is a placeholder message")
  end
end
