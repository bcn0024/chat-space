require 'rails_helper'

describe MessagesController do
  # 複数のexampleで同一のインスタンスを使いたい場合、letメソッド
  # 後述のbeforeメソッドが各exampleの実行前に毎回処理を行うのに対し、letメソッドは初回の呼び出し時のみ実行されます。
  # 複数回行われる処理を一度の処理で実装できるため、テストを高速にすることができます。
  let(:group) { create(:group) }
  let(:user) { create(:user) }
  # 今回はログインをしているかどうかを条件に、contextを用いてテストをグループ分け
  describe '#index' do
  # ログインしている場合
    # アクション内で定義しているインスタンス変数があるか
    # 該当するビューが描画されているか
    context 'log in' do
      before do
        login user  # deviseを用いて「ログインをする」ためのloginメソッドは、/spec/support/controller_macros.rbで定義。
        get :index, params: { group_id: group.id }# messagesのルーティングはgroupsにネストされているため、group_idを含んだパスを生成します。そのため、getメソッドの引数として、params: { group_id: group.id }を渡しています。
      end
# beforeブロックの内部に記述された処理は、各exampleが実行される直前に、毎回実行されます。
# 今回の場合は「ログインをする」「擬似的にindexアクションを動かすリクエストを行う」が共通の処理となるため、beforeの内部に記述
      it 'assigns @message' do
        expect(assigns(:message)).to be_a_new(Message)
          # be_a_newマッチャを利用することで、 対象が引数で指定したクラスのインスタンスかつ未保存のレコードであるかどうか確かめることができます。
          # 今回の場合は、assigns(:message)がMessageクラスのインスタンスかつ未保存かどうかをチェックしています。
      end
         
      it 'assigns @group' do
        expect(assigns(:group)).to eq group
          # @groupはeqマッチャを利用してassigns(:group)とgroupが同一であることを確かめることでテスト
      end

      it 'redners index' do
        expect(response).to render_template :index
        # responseインスタンスとrender_templateマッチャを合わせることによって、
          # example内でリクエストが行われた時の遷移先のビューが、indexアクションのビューと同じかどうか確かめることができます。
      end
    end
  # ログインしていない場合
    # 意図したビューにリダイレクトできているか
    context 'not log in' do
      before do
        get :index, params: { group_id: group.id }
      end

      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to(new_user_session_path)
        # redirect_toマッチャは引数にとったプレフィックスにリダイレクトした際の情報を返すマッチャです。
        # 今回は、非ログイン時にmessagesコントローラのindexアクションを動かすリクエストが行われた際に、ログイン画面にリダイレクトするかどうかを確かめる
      end
    end
  end


  describe '#create' do
    let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }
        # attributes_forはcreate、build同様FactoryBotによって定義されるメソッドで、オブジェクトを生成せずにハッシュを生成する
    context 'log in' do
      before do
        login user
      end

      context 'can save' do
        subject {
          post :create,
          params: params
        }

        it 'count up message' do
          expect{ subject }.to change(Message, :count).by(1)
        end
          # subjectを定義して渡す＝postメソッドでcreateアクションを擬似的にリクエストをした結果という意。
          # changeマッチャは引数が変化したかどうかを確かめるために利用できるマッチャです。
          # change(Message, :count).by(1)と記述することによって、Messageモデルのレコードの総数が1個増えたかどうかを確かめる
        it 'redirects to group_messages_path' do
          subject
          expect(response).to redirect_to(group_messages_path(group))
        end
      end

      context 'can not save' do
        let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, content: nil, image: nil) } }
          # invalid_paramsを定義する際に、attributes_for(:message)の引数に、content: nil, image: nilと記述
          # 擬似的にcreateアクションをリクエストする際にinvalid_paramsを引数として渡してあげることによって、意図的にメッセージの保存に失敗する場合を再現
        subject {
          post :create,
          params: invalid_params
        }

        it 'does not count up' do
          expect{ subject }.not_to change(Message, :count)
        end
          # Rspecで「〜であること」を期待する場合にはtoを使用しますが、「〜でないこと」を期待する場合にはnot_toを使用
          # not_to change(Message, :count)=保存に失敗したこと
        it 'renders index' do
          subject
          expect(response).to render_template :index
        end
      end
    end

    context 'not log in' do

      it 'redirects to new_user_session_path' do
        post :create, params: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end