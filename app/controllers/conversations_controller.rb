class ConversationsController < ApplicationController

  before_action :require_user_signin

  def index
    @conversations = current_user.conversations
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
    @agents = current_user.agents
  end

  def create
    @conversation = Conversation.new(conversation_params)
    @conversation.user_id = current_user.id
    @agents = current_user.agents

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
    @message = @conversation.new_message

    respond_to do |format|
      format.html { redirect_to @conversation }
      format.turbo_stream
    end
  end

  def start_simulation
    steps = params[:steps].to_i
    @conversation = Conversation.find(params[:id])
    ConversationSimulationJob.perform_later(@conversation.id, steps, current_user.email)
    redirect_to @conversation, notice: 'Simulation started'
  end

  private

  def conversation_params
    params.require(:conversation).permit(:title, :topic, agent_ids: [])
  end
end
