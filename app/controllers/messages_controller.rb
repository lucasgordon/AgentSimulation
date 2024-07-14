class MessagesController < ApplicationController
  def show
    @message = Message.find(params[:id])
  end

  def index
    @messages = Message.all
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:message_text, :agent_id, :conversation_id)
  end
end
