class Agent < ApplicationRecord

  MODELS = [
    "gpt-3.5-turbo-0125",
    "gpt-4-turbo",
    "gpt-4o",
  ].freeze


  validates :name, presence: true
  validates :system_prompt, presence: true
  validates :temperature, presence: true
  validates :model, presence: true
  validates :model, inclusion: { in: MODELS }
  validates :temperature, inclusion: { in: 0.0..1.0 }
  validates :top_p, inclusion: { in: 0.0..1.0 }


  has_many :messages
  has_many :conversations, through: :messages

end
