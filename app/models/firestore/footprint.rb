# frozen_string_literal: true

class Firestore::Footprint < Firestore::Base
  COLLECTION_NAME = 'footprint'

  class_attribute :repo
  self.repo = client.col COLLECTION_NAME

  def self.find(document_id)
    snapshot = repo.doc(document_id).get
    snapshot.data.merge({ documentId: snapshot.document_id }) if snapshot.exists?
  end

  def self.add(uid, sakura_uid)
    return if uid == sakura_uid

    ref = repo.doc(uid)
    footprint = ref.get
    history = {}
    # データあり
    if footprint.data.present?
      history = footprint[:history] if footprint.data.key?(:history)
      sakura_history = footprint[:history].select { |k,v|  v == sakura_uid}
      if sakura_history.count == 0
        history[Time.now.to_i] = sakura_uid
      else
        hist = sakura_history.keys.map { |e| e.to_s.to_i  }.sort.reverse
        # 同じ日付の場合は足あとは残さない
        if Time.at(hist[0]).strftime('%Y-%m-%d') == Time.at(Time.now.to_i).strftime('%Y-%m-%d')
          return
        else
          temp = footprint[:history].select { |k,v|  v != sakura_uid}
          temp[Time.now.to_i] = sakura_uid
          history = temp
        end
      end
    else
      # データなし
      history[Time.now.to_i] = sakura_uid
    end
    ref.set({ history: history })


  end

end
