# frozen_string_literal: true

class Firestore::ChatRoom < Firestore::Base
  COLLECTION_NAME = 'chat_room'

  class_attribute :repo
  self.repo = client.col COLLECTION_NAME

  def self.statuses
    %w[非表示 表示]
  end

  def self.all
    repo.order("created_at", "desc").get.map do |article|  # nameの値でソートしてuserの一覧を返す
      article.data.merge({ documentId: chat_room.document_id })  # この辺はお好みでどうぞ
    end
  end

  def self.find_by_uid(uid)
    repo.where('members.'+uid, '==', true).get.map do |chat_room|  # nameの値でソートしてuserの一覧を返す
      chat_room.data.merge({ documentId: chat_room.document_id })  # この辺はお好みでどうぞ
    end
  end

  def self.messages(document_id)
    messages = repo.doc(document_id).collection('messages').get.map do |message|
      message.data.merge({ documentId: message.document_id })
    end
    messages.sort_by { |e| e[:created_at] }
  end

  def self.find(document_id)
    snapshot = repo.doc(document_id).get
    snapshot.data.merge({ documentId: snapshot.document_id }) if snapshot.exists?
  end

  def self.update(article_form)
    params = article_form.attributes
    document_id = params[:id]
    params.delete(:id)
    ref = repo.doc(document_id)
    ref.update(params)
  end

  def self.findroom(uid, sakura_uid)
    repo.where('members.'+uid, '==', true).where('members.'+sakura_uid, '==', true).get.map do |chat_room|
      chat_room.data.merge({ documentId: chat_room.document_id })
    end
  end

  def self.create(uid, sakura_uid)
    data = {}
    data["owner"]               = sakura_uid
    data["members"]             = {uid => true, sakura_uid => true}
    data["unreadCounts"]        = {uid => 0, sakura_uid => 0}
    data["created_at"]          = DateTime.now
    data["updated_at"]          = DateTime.now
    data["status"]              = 1
    data["last_update_message"] = ""
    room_doc_ref = repo.add data
    #p 'room_doc_ref'
    #p room_doc_ref
    #p room_doc_ref.document_id
    repo.doc(room_doc_ref.document_id).get
  end

  def self.post_message(uid, sakura_uid, text)
    repo.where('members.'+uid, '==', true).where('members.'+sakura_uid, '==', true).get.map do |chat_room|
      chat_room.data.merge({ documentId: chat_room.document_id })

      unreads = {uid => true, sakura_uid => false}
      data    = {}
      data["sender"]      = sakura_uid
      data["text"]        = text
      data["created_at"]  = DateTime.now
      data["status"]      = 1
      data["unreads"]     = {uid => true, sakura_uid => false}
      r =  client.col "chat_room/#{chat_room.document_id}/messages"
      r.add(data)

      room_ref = repo.doc(chat_room.document_id)
      room_ref.set({ last_update_message: text }, merge: true)
    end
  end

end
