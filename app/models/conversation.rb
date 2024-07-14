class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :conversation_agents, dependent: :destroy
  has_many :agents, through: :conversation_agents

  accepts_nested_attributes_for :agents, allow_destroy: true

  validate :validate_agents_count


  def new_message
    agent = agents.select{ |agent| agent != last_message_agent }.sample
    message_text = generate_message_text(agent)
    messages.create(agent: agent, message_text: message_text)
  end

  def last_message
    messages.last
  end

  def last_message_agent
    last_message&.agent
  end

  def generate_message_text(agent)
    system_prompt = agent.system_prompt

    context_prompt = prompt(agent)

    message = PromptService.new(content: context_prompt, system: system_prompt, model: agent.model, temperature: agent.temperature).prompt

    message["choices"][0]["message"]["content"]
  end

  def prompt(agent)
    """
    Your name is #{agent.name}.

    You are in a conversation with #{agents.reject { |a| a == agent }.map(&:name).to_sentence}. The last message was from #{last_message_agent&.name}. If there was no last message, you get to
    say the first message, congrats! You can say anything you want.

    Respond to the last message with your own message. Limit your response to maximum three sentences. 

    The history of previous messages in this conversation, if any, are: #{messages.map { |message| "#{message.agent.name} said: #{message.message_text}" }.join("\n")}
    """
  end



  private

  def validate_agents_count
    errors.add(:agents, "must be between 1 and 4") unless agents.size.between?(1, 4)
  end
end
