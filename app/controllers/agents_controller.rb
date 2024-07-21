class AgentsController < ApplicationController

  before_action :require_user_signin

  def index
    @agents = current_user.agents
  end

  def new
    @agent = Agent.new
  end

  def edit
    @agent = Agent.find(params[:id])
  end

  def update
    @agent = Agent.find(params[:id])
    if @agent.update(agent_params)
      redirect_to agents_path
    else
      render :edit
    end
  end

  def show
    @agent = Agent.find(params[:id])
  end

  def destroy
    @agent = Agent.find(params[:id])
    @agent.destroy
    redirect_to agents_path
  end

  def create
    @agent = Agent.new(agent_params)
    @agent.user_id = current_user.id
    if @agent.save
      redirect_to agents_path
    else
      render :new
    end
  end

  private

  def agent_params
    params.require(:agent).permit(:name, :system_prompt, :temperature, :top_p,:model)
  end


end
