class MessagesController < ApplicationController
  before_action :set_group
  #  messageコントローラーが呼ばれた時に最初に読み込まれるメソッドを選択するメソッド→その次にindexが呼ばれる


  def index
    @message = Message.new
    @messages = @group.messages.includes(:user)
  end

  def create
    @message = @group.messages.new(message_params)
    if @message.save
      redirect_to group_messages_path(@group), notice: 'メッセージが送信されました'
    else
      @messages = @group.messages.includes(:user)
      flash.now[:alert] = 'メッセージを入力してください。'
      render :index
    end
  end


  private

  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
  end

  def set_group
    @group = Group.find(params[:group_id])
    #  グループモデルからクリックのあったグループIDを携えたものを変数に代入、これでmessage/viewでも使用可能→before actionへ
  end
end
