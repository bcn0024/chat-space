$(function() {
  function addUser(user) {
    let html = `
      <div class="chat-group-user clearfix">
        <p class="chat-group-user__name">${user.name}</p>
        <div class="user-search-add chat-group-user__btn chat-group-user__btn--add" data-user-id="${user.id}" data-user-name="${user.name}">追加</div>
      </div>
    `;
    $("#user-search-result").append(html);
    // ${} を使用する事でテンプレートリテラル内で式展開が可能です。これを使用してユーザーの名前などを表示できるよう実装
    // appendメソッド を使用してHTMLを描画
  }

  function addNoUser() {
    let html = `
      <div class="chat-group-user clearfix">
        <p class="chat-group-user__name">ユーザーが見つかりません</p>
      </div>
    `;
    $("#user-search-result").append(html);
  }
  function addDeleteUser(name, id) {
    let html = `
    <div class="chat-group-user clearfix" id="${id}">
      <p class="chat-group-user__name">${name}</p>
      <div class="user-search-remove chat-group-user__btn chat-group-user__btn--remove js-remove-btn" data-user-id="${id}" data-user-name="${name}">削除</div>
    </div>`;
    $(".js-add-user").append(html);
  }
  function addMember(userId) {
    let html = `<input value="${userId}" name="group[user_ids][]" type="hidden" id="group_user_ids_${userId}" />`;
    $(`#${userId}`).append(html);
    // ユーザーの追加や削除の情報は addMember というメソッドを作成してコントロールしています。
    // ここではメンバーを追加する際に情報を user_idsへ追加できるような仕組みを作り、削除ボタンを押すと同時にその情報も削除されるように実装
  }
  $("#user-search-field").on("keyup", function() {
    let input = $("#user-search-field").val();
    $.ajax({
      type: "GET",
      url: "/users",
      data: { keyword: input },
      dataType: "json"
    })
      .done(function(users) {
        $("#user-search-result").empty();
          //  検索結果が該当する場合と、しない場合で条件分岐をします。
          //  検索結果は配列に格納されるので、lengthメソッドを使用して条件分岐が可能
        if (users.length !== 0) {
          users.forEach(function(user) {
            addUser(user);
          });
          // 検索結果が該当ありの場合は、forEach文を使用しユーザーごとHTMLを描画
          // addUserという関数を定義し、HTMLを用意します。
        } else if (input.length == 0) {
          return false;
          // 返り値がない場合はreturn falseと記述し、返り値がない事を伝える
        } else {
          addNoUser();
        }
      })
      .fail(function() {
        alert("通信エラーです。ユーザーが表示できません。");
      });
  });
  $(document).on("click", ".chat-group-user__btn--add", function() {
    console.log
    const userName = $(this).attr("data-user-name");
    const userId = $(this).attr("data-user-id");
    $(this)
      .parent()
      .remove();
    addDeleteUser(userName, userId);
    addMember(userId);
  });
  $(document).on("click", ".chat-group-user__btn--remove", function() {
    // $(document).onとして常に最新のHTMLの情報を取得できるようにしてください。
    // $(document).onを用いることで、Ajax通信で作成されたHTMLの情報を取得することができます。
    // 今回だとappendさせて作成したHTMLから情報を取得する際、documentを用いることで値の取得を可能にしています。
    $(this)
      .parent()
      .remove();
      // 追加ボタンの対象であるユーザー情報を変数へ代入し、HTMLを描画します。
      // その際、検索結果欄からメンバー欄へ移動するように見せるために検索結果欄からremoveメソッドを使用してHTMLは削除
  });
});