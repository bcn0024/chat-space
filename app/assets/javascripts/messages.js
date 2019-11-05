$(function () {

  function buildHTML(message){
    img = message.image ? `<img class="lower-message__image" src="${message.image}" alt="Img cliants03">` : "";
    var html =`<div class="wrapper__chat-main__messages__message" data-message-id="${message.id}">
                   <div class="wrapper__chat-main__messages__message__upper-info">
                     <p class="wrapper__chat-main__messages__message__upper-info__talker">
                       ${message.user_name}
                     </p>
                     <p class="wrapper__chat-main__messages__message__upper-info__date">
                       ${message.date}
                     </p>
                   </div>
                   <p class="wrapper__chat-main__messages__message__text">
                   </p>
                     <p class="wrapper__chat-main__messages__message__text__content">
                       ${message.content}
                     </p>
                       ${img}
                    <p></p>
               </div>`
 
    return html;
   }

  $('#new_message').on('submit', function(e){
    e.preventDefault();
    var formData = new FormData(this);
    var url = $(this).attr('action');
    $.ajax({
      url: url,  //同期通信でいう『パス』
      type: 'POST',  //同期通信でいう『HTTPメソッド』
      data: formData,  
      dataType: 'json',
      processData: false,
      contentType: false
    })

    .always(function(){
      $('.wrapper__chat-main__form__new_message__submit-btn').prop('disabled', false);  //ここで解除している
    })

    .done(function(chat){

      var html = buildHTML(chat);
      $('.wrapper__chat-main__messages').append(html);
      $('.wrapper__chat-main__messages').animate({ scrollTop: $('.wrapper__chat-main__messages')[0].scrollHeight });
      $('#new_message')[0].reset();
        // jQueryのセレクタは複数のオブジェクトを拾おうとします。
        // [0]はその0番目の要素をDOMとしてつかんでいます
        // valだと写真までもはリセットされない。
    })
    .fail(function() {
      alert("メッセージ送信に失敗しました");
    });
  })

  var reloadMessages = function () {
    if (window.location.href.match(/\/groups\/\d+\/messages/)){//今いるページのリンクが/groups/グループID/messagesのパスとマッチすれば以下を実行。
      var last_message_id = $('.wrapper__chat-main__messages__message:last').data("message-id"); 
      //カスタムデータ属性を利用し、ブラウザに表示されている最新メッセージのidを取得
      //dataメソッドで.messageにある:last最後のカスタムデータ属性を取得しlast_message_idに代入。
      // var group_id = $(".group").data("group-id");

      $.ajax({ //ajax通信で以下のことを行う
        url: "api/messages", 
        // ajax関数のurlに何も指定しなかった場合、リクエストのURLは現在ブラウザに表示されているパスと同様になります。つまり今回の場合は、groups/id番号となります。
        // 対してurlに文字列で値を指定すると、自動的に現在ブラウザに表示されているURLの後に繋がる形になります。
        // 例えば現在のURLがgroups/3なら、urlに"hoge"と指定すればリクエストのURLはgroups/3/hogeとなる
        //ルーティングで設定した通り/groups/id番号/api/messagesとなるよう文字列を書く
        //サーバを指定。今回はapi/message_controllerに処理を飛ばす
        type: 'get', //メソッドを指定
        dataType: 'json', //データはjson形式
        data: {last_id: last_message_id} //飛ばすデータは先ほど取得したlast_message_id。またparamsとして渡すためlast_idとする。
      })

      .done(function (messages) { //通信成功したら、controllerから受け取ったデータ（messages)を引数にとって以下のことを行う
        var insertHTML = '';//追加するHTMLの入れ物を作る
        messages.forEach(function (message) {//配列messagesの中身一つ一つを取り出し、HTMLに変換したものを入れ物に足し合わせる
          insertHTML = buildHTML(message); //メッセージが入ったHTMLを取得
          $('.wrapper__chat-main__messages').append(insertHTML);//メッセージを追加
        })
        $('.wrapper__chat-main__messages').animate({scrollTop: $('.wrapper__chat-main__messages')[0].scrollHeight}, 'fast');//最新のメッセージが一番下に表示されようにスクロールする。
      })
      .fail(function () {
        alert('自動更新に失敗しました');//ダメだったらアラートを出す
      });
    }
  };

  setInterval(reloadMessages, 5000);//5000ミリ秒ごとにreloadMessagesという関数を実行し自動更新を行う。
  //$(function(){});の閉じタグの直上(処理の最後)に以下のように追記

});