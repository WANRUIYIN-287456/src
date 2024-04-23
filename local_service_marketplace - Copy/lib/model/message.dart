class Chat {
  String? chatId;
  String? sellerId;
  String? userId;
  String? chatBody;
  String? chatDate;
  String? chatSendbyme;

  Chat({
    this.chatId,
    this.sellerId,
    this.userId,
    this.chatBody,
    this.chatDate,
    this.chatSendbyme,
  });

  Chat.fromJson(Map<String?, dynamic> json) {
    chatId = json['chat_id'];
    sellerId = json['seller_id'];
    userId = json['user_id'];
    chatBody = json['chat_body'];
    chatDate = json['chat_date'];
    chatSendbyme = json['chat_sendbyme'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['chat_id'] = chatId;
    data['seller_id'] = sellerId;
    data['user_id'] = userId;
    data['chat_body'] = chatBody;
    data['chat_date'] = chatDate;
    data['chat_sendbyme'] = chatSendbyme;
    return data;
  }
}
