# frozen_string_literal: true

require "google/cloud/storage"

class Firestorage::Base
  class_attribute :storage
  class_attribute :bucket
  self.storage = storage = Google::Cloud::Storage.new(
        project_id: "p-chat-686ca",
        credentials: "config/firebase/p-chat-686ca-firebase-adminsdk-80i4n-0f49b20c50.json"
      )
  self.bucket = storage.bucket "p-chat-686ca.appspot.com"
end
