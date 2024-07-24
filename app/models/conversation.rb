class Conversation < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :conversation_agents, dependent: :destroy
  has_many :agents, through: :conversation_agents

  belongs_to :user

  accepts_nested_attributes_for :agents, allow_destroy: true

  validate :validate_agents_count


  def new_message
    ActiveRecord::Base.transaction do
      agent = agents.select{ |agent| agent != last_message_agent }.sample
      message_text = generate_message_text(agent)
      messages.create(agent: agent, message_text: message_text)
    end
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
    Continue.

    Here's the history of the conversation so far:
    #{messages.map { |message| "#{message.agent.name} said: #{message.message_text}" }.join("\n")}
    """
  end

  def reset
    messages.destroy_all
  end

  def simulate_conversation(steps)
    steps.times do
      new_message
      sleep(5)
    end
  end



  private

  def validate_agents_count
    errors.add(:agents, "must be between 1 and 4") unless agents.size.between?(1, 4)
  end
end
