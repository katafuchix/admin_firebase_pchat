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
end
