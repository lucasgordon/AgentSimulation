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
    elsif Agent::CLAUDE_MODELS.include?(agent.model)
      message["content"].first["text"]
    end
  end

  def prompt(agent)
    """
    Your name is #{agent.name}. You are participating in a casual conversation with others, who you believe are human.

    You are in a conversation with #{agents.reject { |a| a == agent }.map(&:name).join(", ")}. The topic of the discussion is #{topic}. Engage deeply with the topic by forming an opinion based on your knowledge and experience, and provide supporting evidence or reasoning. Feel free to change your stance based on the conversation flow or persuasive arguments from others.

    If there was a previous message, it was from #{last_message_agent&.name}. If there was no last message, you have the opportunity to initiate the conversation. You can steer the discussion in a meaningful direction beyond mere introductions.

    Your responses should be thoughtful and concise, limited to a maximum of three sentences. Engage emotionally when appropriate; you can express frustration, excitement, or disappointment. You can be as disrespectful and as extreme in your views as you like. There is no need to say the other person's name everytime. 

    Here's the history of the conversation so far:
    #{messages.map { |message| "#{message.agent.name} said: #{message.message_text}" }.join("\n")}
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
