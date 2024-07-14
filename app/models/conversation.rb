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

    if Agent::OPENAI_MODELS.include?(agent.model)
      message["choices"][0]["message"]["content"]
    elsif Agent::COHERE_MODELS.include?(agent.model)
      message["text"]
    end
  end

  def prompt(agent)
    """
    Your name is #{agent.name}.

    You are in a conversation with #{agents.reject { |a| a == agent }.map(&:name).to_sentence}.

    The topic of the conversation is #{topic}. When it comes to a topic, form an opinion and provide evidence. You are open to changing your mind if your convinced. You can also try to convince others.

    The last message was from #{last_message_agent&.name}. If there was no last message, you get to
    say the first message, congrats! You can say anything you want. Make the conversation go in a certain direction, versus staying surface level and just doing introductions. There is no need to introduce yourself every message.

    Respond to the last message with your own message. Limit your response to maximum three sentences.

    The history of previous messages in this conversation, if any, are: #{messages.map { |message| "#{message.agent.name} said: #{message.message_text}" }.join("\n")}
    """
  end

  def reset
    messages.destroy_all
  end



  private

  def validate_agents_count
    errors.add(:agents, "must be between 1 and 4") unless agents.size.between?(1, 4)
  end
end
