class MessagesController < ApplicationController
  before_action :set_group
  #  messageコントローラーが呼ばれた時に最初に読み込まれるメソッドを選択するメソッド→その次にindexが呼ばれる


  def index
    @message = Message.new
    @messages = @group.messages.includes(:user)
  end

  def create
    @message = Message.create(message_params)
    #  送信されたメッセージをパラムスとしてグループ内に紐づいたメッセージとして変数へ代入
    respond_to do |format|
      format.html { redirect_to group_messages_path, notice: "メッセージを送信しました" }
      format.json
    end
  end


  private

  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id, group_id: params[:group_id])
  end

  def set_group
    @group = Group.find(params[:group_id])
    #  グループモデルからクリックのあったグループIDを携えたものを変数に代入、これでmessage/viewでも使用可能→before actionへ
  end
end
