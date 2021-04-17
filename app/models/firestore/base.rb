# frozen_string_literal: true

require 'google/cloud/firestore'

class Firestore::Base
  class_attribute :client
  self.client = firestore = Google::Cloud::Firestore.new(
        project_id: "p-chat-686ca",
        credentials: "config/firebase/p-chat-686ca-firebase-adminsdk-80i4n-0f49b20c50.json"
      )
end
