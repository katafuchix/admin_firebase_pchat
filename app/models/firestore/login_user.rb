# frozen_string_literal: true

class Firestore::LoginUser < Firestore::Base
  COLLECTION_NAME = 'login_user'

  class_attribute :repo
  self.repo = client.col COLLECTION_NAME

  def self.all
    repo.order("created_at", "desc").get.map do |user|  # nameの値でソートしてuserの一覧を返す
      user.data.merge({ documentId: user.document_id })  # この辺はお好みでどうぞ
    end
  end

  def self.find(document_id)
    snapshot = repo.doc(document_id).get
    snapshot.data.merge({ documentId: snapshot.document_id }) if snapshot.exists?
  end
end
