$(function(){
  function buildHTML(chat){
   img = chat.image ? `<img class="lower-message__image" src="${chat.image}" alt="Img cliants03">` : "";
   var html =`<div class="wrapper__chat-main__messages__message" id="${chat.id}">
                  <div class="wrapper__chat-main__messages__message__upper-info">
                    <p class="wrapper__chat-main__messages__message__upper-info__talker">
                      ${chat.name}
                    </p>
                    <p class="wrapper__chat-main__messages__message__upper-info__date">
                      ${chat.date}
                    </p>
                  </div>
                  <p class="wrapper__chat-main__messages__message__text">
                  </p>
                    <p class="wrapper__chat-main__messages__message__text__content">
                      ${chat.text}
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
      $('.wrapper__chat-main__form__new_message__input-box__text').val('')
    })
    .fail(function() {
      alert("メッセージ送信に失敗しました");
    });
  })
});