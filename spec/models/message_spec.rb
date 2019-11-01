require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#create' do
    context 'can save' do  # テストのケースがメッセージを保存できる場合、メッセージを保存できない場合で分かれています。
                           # このように、特定の条件でテストをグループ分けしたい場合、contextを使う
      it 'is valid with content' do
        expect(build(:message, image: nil)).to be_valid
      end
        # buildメソッドは、カラム名: 値の形で引数を渡すことによって、ファクトリーで定義されたデフォルトの値を上書きすることができます。
        # 今回は、メッセージがあれば保存できることを確かめたいので、image: nilを引数として、画像を持っていないインスタンスを生成
      it 'is valid with image' do
        expect(build(:message, content: nil)).to be_valid
      end
        # 同様に、画像があれば保存できる場合についても、
        # content: nilをbuildメソッドの引数とすることによって、メッセージを持っていないインスタンスを生成
      it 'is valid with content and image' do
        expect(build(:message)).to be_valid
        # メッセージと画像があれば保存できる場合は、ファクトリーでデフォルトの値が定義されているので、build(:message)と記述するだけ
      end
    end

    context 'can not save' do
      it 'is invalid without content and image' do
        message = build(:message, content: nil, image: nil)  # メッセージも画像もないと保存できない場合については、buildメソッドの引数でメッセージも画像もnilにすることによって、必要なインスタンスを生成
        message.valid?  # 作成したインスタンスがバリデーションによって保存ができない状態かチェックするため、valid?メソッドを利用
        expect(message.errors[:content]).to include('を入力してください')
      end                                         # "translation missing: ja.activerecord.errors.models.message.attributes.content.blank"
      
      # errorsメソッドを使用することによって、バリデーションにより保存ができない状態である場合なぜできないのかを確認することができます。
        # contentもimageもnilの今回の場合、'を入力してください'というエラーメッセージが含まれることが分かっているため、includeマッチャを用いて以下のようにテストを記述することができます。
      # expectの引数に関して、message.errors[:カラム名]と記述することによって、そのカラムが原因のエラー文が入った配列を取り出すことができます。
        # こちらに対して、includeマッチャを利用してエクスペクテーションを作成
      it 'is invalid without group_id' do
        message = build(:message, group_id: nil)
        message.valid?
        expect(message.errors[:group]).to include('を入力してください')
      end

      it 'is invaid without user_id' do
        message = build(:message, user_id: nil)
        message.valid?
        expect(message.errors[:user]).to include('を入力してください')
      end
    end
  end
end