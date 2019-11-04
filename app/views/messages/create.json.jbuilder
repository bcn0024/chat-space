json.id    @message.id
json.text  @message.content
json.name  @message.user.name
json.date  @message.created_at.strftime("%Y/%m/%d %H:%M")
json.image @message.image.url