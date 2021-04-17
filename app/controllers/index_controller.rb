require "google/cloud/firestore"

class IndexController < ApplicationController
  def index

    firestore = Google::Cloud::Firestore.new(
      project_id: "p-chat-686ca",
      credentials: "config/firebase/p-chat-686ca-firebase-adminsdk-80i4n-0f49b20c50.json"
    )

    doc_ref  = firestore.col("login_user").doc(1)
    snapshot = doc_ref.get
    if snapshot.exists?
      p "#{snapshot.document_id} data: #{snapshot.data}."
    else
      p "Document #{snapshot.document_id} does not exist!"
    end

    cities_ref = firestore.col("login_user")
    p cities_ref.get
    p cities_ref.get.map{|item| item[:id]}.size

    cities_ref = firestore.col("login_user")
    query = cities_ref.order("created_at").limit(10) #.where "id", "=", 1

    query.get do |city|
      puts "#{city.document_id} data: #{city.data[:name]}."
    end

    @users = query.get
    p @users
  end
end
