# frozen_string_literal: true

class Firestore::Article < Firestore::Base
  COLLECTION_NAME = 'article'

  class_attribute :repo
  self.repo = client.col COLLECTION_NAME

  def self.statuses
    %w[非表示 表示]
  end

  def self.all
    repo.order("created_at", "desc").get.map do |article|  # nameの値でソートしてuserの一覧を返す
      article.data.merge({ documentId: article.document_id })  # この辺はお好みでどうぞ
    end
  end

  def self.find_by_uid(uid)
    repo.where('uid', '==', uid).order("created_at", "desc").get.map do |article|  # nameの値でソートしてuserの一覧を返す
      article.data.merge({ documentId: article.document_id })  # この辺はお好みでどうぞ
    end
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

  def self.create(text)
    data = {}
    data["uid"]               = $sakura[:documentId]
    data["text"]              = text
    data["status"]            = 1
    data["created_at"]        = DateTime.now
    data["user_profile_image_url"]  = $sakura[:profile_image_url]
    data["user_prefecture_id"]      = $sakura[:prefecture_id]
    data["user_sex"]                = $sakura[:sex]
    data["user_nickname"]           = $sakura[:nickname]
    data["parentKey"]         = ""
    data["toKey"]             = ""
    data["toUid"]             = ""
    p data
    doc_ref = repo.add data
    repo.doc(doc_ref.document_id).get
  end
end
