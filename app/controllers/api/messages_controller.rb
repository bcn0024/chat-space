
class Api::MessagesController < ApplicationController
  def index
    # ルーティングでの設定によりparamsの中にgroup_idというキーでグループのidが入るので、これを元にDBからグループを取得する
    # #今いるグループの情報をパラムスの値を元にDBから取得。
    @group = Group.find(params[:group_id]) #今いるグループの情報をパラムスの値を元にDBから取得。
    @messages = @group.messages.includes(:user).where('id > ?', params[:last_id]) 
    #グループが所有しているメッセージの中から、params[:last_id]よりも大きいidがないかMessageから検索して、@messagesに代入。
  end
end


# ブラウザに表示されているものより新しいメッセージのみをDBから取得し、JSON形式でレスポンスしましょう。
# 数秒に一度このアクションを動かすことで、自動更新を実現

# json形式で情報をレスポンスするアクションは、概念としてはWebAPIと呼ばれるものに相当します。
# Railsの場合は、「jsonをレスポンスするアクション」がWebAPIにあたります。
# 一緒に開発する人にわかりやすいよう、WebAPIにあたるアクションを書くコントローラのファイルは全て「api」というディレクトリに置くのがお作法です。
# apiディレクトリは、controllersディレクトリの直下に作ります。

# Rubyのクラス名は、このように::で繋げて装飾することができます。これを、名前空間またはnamespaceといいます。
# プログラムがクラスを判別する際はどのディレクトリに入っているかでの判別はできないため、
# 名前空間を利用するルールになっています。こうすることで、Railsは間違えることなく2つのコントローラを区別するようプログラムされています。