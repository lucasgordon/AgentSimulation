# frozen_string_literal: true

  class Prompt
    attr_reader :context, :instructions

    def initialize(context:, instructions:)
      @context = context
      @instructions = instructions
    end

    def perform(context: @context, instructions: @instructions)
      prompt = "#{context}\n#{instructions}"
      raw_output = PromptService.prompt(content: prompt)
      raw_output["choices"].map { |choice| choice.dig("message", "content") }.join("\n")
    end
  end
