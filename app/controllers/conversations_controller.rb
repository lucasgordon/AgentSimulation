class ConversationsController < ApplicationController
  def index
    @conversations = Conversation.all
  end

  def show
    @conversation = Conversation.find(params[:id])
    @agents = @conversation.agents

  end

  def new
    @conversation = Conversation.new
    @agents = Agent.all
  end

  def create
    @conversation = Conversation.new(conversation_params)
    @agents = Agent.all

    agent_ids = params[:conversation][:agent_ids]
    if agent_ids.present?
      selected_agents = Agent.find(agent_ids)
      @conversation.agents = selected_agents
    end

    if @conversation.save
      redirect_to @conversation
    else
      render 'new'
    end
  end

  def increment
    @conversation = Conversation.find(params[:id])
    @conversation.new_message
    redirect_to @conversation
  end

  private

  def conversation_params
    params.require(:conversation).permit(:title, agent_ids: [])
  end
end
