# frozen_string_literal: true


require 'cohere'
class PromptService
  TEMPERATURE_RANGE = 0.0..1.0

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

  class << self
    def prompt(...)
      new(...).prompt
    end
  end

  def initialize(content:, system: nil, model: "gpt-4o", temperature: 0.5, format: nil)
    raise ArgumentError, "Invalid model" unless (OPENAI_MODELS + COHERE_MODELS).include?(model)
    raise ArgumentError, "Invalid temperature" unless TEMPERATURE_RANGE.include?(temperature)

    @content = content
    @system = system
    @model = model
    @temperature = temperature
    @format = format
  end

  def prompt
    if OPENAI_MODELS.include?(@model)
      openai_client.chat(parameters: openai_params)
    elsif COHERE_MODELS.include?(@model)
      cohere_client.chat(**cohere_params)
    else
      raise "Unsupported model"
    end
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new
  end

  def cohere_client
    @cohere_client ||= Cohere::Client.new(api_key: ENV['COHERE_API_KEY'])
  end

  def openai_params
    messages = []
    messages << { role: "system", content: @system } if @system.present?
    messages << { role: "user", content: @content }
    {
      model: @model,
      messages: messages,
      temperature: @temperature,
    }
  end

  def cohere_params
    preamble = @system.present? ? @system : ""
    {
      model: @model,
      preamble: preamble,
      message: @content,
      temperature: @temperature
    }
  end

  def json_format
    { response_format: { type: "json_object" } }
  end
end
