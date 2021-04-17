require "google/cloud/firestore"

class IndexController < ApplicationController
  def index

    @page = params['page'].to_i || 1
    #firestore = Google::Cloud::Firestore.new(
    #  project_id: "p-chat-686ca",
    #  credentials: "config/firebase/p-chat-686ca-firebase-adminsdk-80i4n-0f49b20c50.json"
    #)

    firestore = Firestore::Base.client
=begin
    doc_ref  = firestore.col("login_user").doc(1)
    snapshot = doc_ref.get
    if snapshot.exists?
      p "#{snapshot.document_id} data: #{snapshot.data}."
    else
      p "Document #{snapshot.document_id} does not exist!"
    end
=end

    users_ref = firestore.col("login_user")
    item_total = users_ref.get.map{|item| item[:id]}.size
    p item_total

    all_page = (item_total / 20).ceil


    @max_page = all_page
    @current = @page
    @pagination = {}
    @pagination['≪'] = 1 if @current >= 3
    @pagination['<'] = @current - 1 if @current != 1

    if @current + 2 >= @max_page
      @pagination.merge!({@max_page - 2 => @max_page - 2, @max_page - 1 => @max_page - 1, @max_page => @max_page})
      delete_list = [0, -1]
      @pagination.delete_if do |key, value|
        delete_list.include?(value)
      end
    else
      @pagination.merge!({@current => @current, @current + 1 => @current + 1, @current + 2 => @current + 2})
    end

    @pagination['>'] = @current + 1 if @current != @max_page
    @pagination['≫'] = @max_page if @current <= @max_page - 3

    #users_ref = firestore.col("login_user")
    query = users_ref.order("created_at", "desc").limit(20) #.where "id", "=", 1

    #query.get do |city|
    #  puts "#{city.document_id} data: #{city.data}."
    #end

    @users = query.get
    #p @users
  end
end
