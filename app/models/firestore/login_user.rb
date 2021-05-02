# frozen_string_literal: true

class Firestore::LoginUser < Firestore::Base
  COLLECTION_NAME = 'login_user'

  def self.genders
    %w[未設定 男性 女性]
  end

  def self.prefectures
    %w[未設定 東京都 神奈川県 埼玉県 千葉県 大阪府 京都府 兵庫県 奈良県 愛知県 岐阜県 三重県 福岡県 北海道 青森県 岩手県 宮城県 秋田県 山形県 福島県 茨城県 栃木県 群馬県 新潟県 富山県 石川県 福井県 山梨県 長野県 静岡県 滋賀県 和歌山県 鳥取県 島根県 岡山県 広島県 山口県 徳島県 香川県 愛媛県 高知県 佐賀県 長崎県 熊本県 大分県 宮崎県 鹿児島県 沖縄県 海外]
  end

  def self.statuses
    %w[非表示 表示]
  end

  class_attribute :repo
  self.repo = client.col COLLECTION_NAME

  def self.all(nickname)
    if nickname != ''
      repo.where("nickname", '==', nickname).where("sakura", '==', 0).order("created_at", "desc").get.map do |user|
          user.data.merge({ documentId: user.document_id })  # この辺はお好みでどうぞ
      end
    else
      repo.where("sakura", '==', 0).order("created_at", "desc").get.map do |user|
          user.data.merge({ documentId: user.document_id })  # この辺はお好みでどうぞ
      end
    end
  end

  def self.sakura(nickname='')
    if nickname != ''
      repo.where("nickname", '==', nickname).where("sakura", '==', 1).order("last_login_date", "desc").get.map do |user|
          user.data.merge({ documentId: user.document_id })  # この辺はお好みでどうぞ
      end
    else
      repo.where("sakura", '==', 1).order("last_login_date", "desc").get.map do |user|
          user.data.merge({ documentId: user.document_id })  # この辺はお好みでどうぞ
      end
    end
    #repo.where("sakura", '==', 1).order("created_at", "desc").get.map do |user|
    #    user.data.merge({ documentId: user.document_id })  # この辺はお好みでどうぞ
    #end
  end

=begin
  def self.all
    repo.order("created_at", "desc").get.map do |user|
      user.data.merge({ documentId: user.document_id })  # この辺はお好みでどうぞ
    end
  end
=end

  def self.find(document_id)
    snapshot = repo.doc(document_id).get
    snapshot.data.merge({ documentId: snapshot.document_id }) if snapshot.exists?
  end

  def self.update(user_form)
    params = user_form.attributes
    document_id = params[:id]
    params.delete(:id)
    ref = repo.doc(document_id)
    ref.update(params)
  end

  def self.updateTime(document_id)
    user_ref = repo.doc(document_id)
    user_ref.set({ last_login_date: DateTime.now }, merge: true)
  end

end
