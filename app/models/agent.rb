class Agent < ApplicationRecord

  MODELS = [
    "gpt-3.5-turbo-0125",
    "gpt-4-turbo",
    "gpt-4o",
    "command-r-plus",
    "command-r",
    "command-nightly",
    "command",
    "claude-3-opus-20240229",
    "claude-3-sonnet-20240229",
    "claude-3-haiku-20240307",
    "gemini-pro"
  ].freeze

  OPENAI_MODELS = [
    "gpt-3.5-turbo-0125",
    "gpt-4-turbo",
    "gpt-4o"
  ].freeze

  COHERE_MODELS = [
    "command-r-plus",
    "command-r",
    "command-nightly",
    "command"
  ].freeze

  CLAUDE_MODELS = [
    "claude-3-opus-20240229",
    "claude-3-sonnet-20240229",
    "claude-3-haiku-20240307"
  ].freeze

  GEMINI_MODELS = [
    "gemini-pro"
  ]


  validates :name, presence: true
  validates :system_prompt, presence: true
  validates :temperature, presence: true
  validates :model, presence: true
  validates :model, inclusion: { in: MODELS }
  validates :temperature, inclusion: { in: 0.0..1.0 }
  validates :top_p, inclusion: { in: 0.0..1.0 }


  has_many :messages, dependent: :destroy
  has_many :conversation_agents, dependent: :destroy
  has_many :conversations, through: :conversation_agents, dependent: :destroy

  belongs_to :user


end
