json.array! @messages do |message|
  json.content      message.content
  json.image        message.image.url
  json.date         message.created_at.strftime("%Y/%m/%d %H:%M")
  json.user_name    message.user.name
  json.id           message.id
end
# この時取得するメッセージは複数ある可能性がある。
# (更新タイミングによっては複数のメッセージが投稿されている)ため、jsonを配列でレスポンスする形にします。