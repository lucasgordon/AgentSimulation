class AgentsController < ApplicationController
  def index
    @agents = Agent.all
  end

  def new
    @agent = Agent.new
  end

  def show
    @agent = Agent.find(params[:id])
  end

  def create
    @agent = Agent.new(agent_params)
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
