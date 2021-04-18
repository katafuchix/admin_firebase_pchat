# frozen_string_literal: true

class Firestore::Article < Firestore::Base
  COLLECTION_NAME = 'article'

  class_attribute :repo
  self.repo = client.col COLLECTION_NAME

  def self.all
    repo.order("created_at", "desc").get.map do |article|  # nameの値でソートしてuserの一覧を返す
      article.data.merge({ documentId: article.document_id })  # この辺はお好みでどうぞ
    end
  end

  def self.find(document_id)
    snapshot = repo.doc(document_id).get
    snapshot.data.merge({ documentId: snapshot.document_id }) if snapshot.exists?
  end
end
