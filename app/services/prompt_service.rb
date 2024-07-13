# frozen_string_literal: true

  class PromptService
    MODELS = [
      "gpt-3.5-turbo-0125",
      "gpt-4-turbo",
      "gpt-4o",
    ].freeze

    TEMPERATURE_RANGE = 0.0..2.0

    class << self
      def prompt(...)
        new(...).prompt
      end
    end

    def initialize(content:, system: nil, model: "gpt-4o", temperature: 0.1, format: nil)
      raise ArgumentError, "Invalid model" if MODELS.exclude?(model)
      raise ArgumentError, "Invalid temperature" if TEMPERATURE_RANGE.exclude?(temperature)

      @content = content
      @system = system
      @model = model
      @temperature = temperature
      @format = format
    end

    def prompt
      client.chat(parameters: chat_params)
    end

    private

    def client
      @client = OpenAI::Client.new
    end

    def chat_params
      messages = []
      messages << { "role": "system", "content": @system } if @system.present?
      messages << { "role": "user", "content": @content }
      params = {
        model: @model,
        messages: messages,
        temperature: @temperature,
      }
      params.merge!(json_format) if @format == "json"
      params
    end

    def json_format
      {
        response_format: { type: "json_object" },
        model: @model,
      }
    end
  end
