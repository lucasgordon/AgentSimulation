class ConversationsController < ApplicationController
  def index
    @conversations = Conversation.all
  end

  def show
    @conversation = Conversation.find(params[:id])
    @agents = @conversation.agents

  end

  def edit
    @conversation = Conversation.find(params[:id])
    @agents = Agent.all
  end

  def update
    @conversation = Conversation.find(params[:id])
    @agents = Agent.all

    agent_ids = params[:conversation][:agent_ids]
    if agent_ids.present?
      selected_agents = Agent.find(agent_ids)
      @conversation.agents = selected_agents
    end

    if @conversation.update(conversation_params)
      redirect_to @conversation
    else
      render 'edit'
    end
  end

  def destroy
    @conversation = Conversation.find(params[:id])
    @conversation.destroy

    redirect_to conversations_path
  end

  def reset
    @conversation = Conversation.find(params[:id])
    @conversation.reset
    redirect_to @conversation
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
    params.require(:conversation).permit(:title, :topic, agent_ids: [])
  end
end
