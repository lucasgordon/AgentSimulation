class ConversationSimulationJob < ApplicationJob
  queue_as :default

  def perform(conversation_id, steps, user_email)
    conversation = Conversation.find(conversation_id)
    conversation.simulate_conversation(steps)
    #UserMailer.conversation_complete_notification(user_email, conversation).deliver_later
  end
end
