class RoomController < ApplicationController
  before_action :set_room, only: [:show, :destroy, :edit, :update]

  def index
    @page = (params['page'] || 1).to_i

    firestore = Firestore::Base.client

    users_ref  = Firestore::LoginUser.repo
    all_list   = Firestore::LoginUser.all
    item_total = all_list.size
    page_ids   = all_list.map { |user| user[:documentId] }.each_slice(20).map { |n| n.first }
    #p page_ids
    #p all_list.last
    #p item_total

    all_page = (item_total / 20).ceil + 1

    @max_page = all_page
    @current = @page
    @pagination = {}
    @pagination['<<'] = 1 if @current >= 3
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
    @pagination['>>'] = @max_page if @current <= @max_page - 3

    c_page = @page - 1
    document_id = page_ids[c_page]
    user = Firestore::LoginUser.find(document_id)
    query = users_ref.where("created_at", '<=', user[:created_at]).order("created_at", "desc").limit(20)

    @users = query.get
  end


  def show
    document_id = params[:id]
    @messages = Firestore::ChatRoom.messages(document_id)
    @owner  = Firestore::LoginUser.find(@room[:owner])
    userId  = @room[:members].keys.select { |v| v.to_s != @room[:owner] }.first
    @member = Firestore::LoginUser.find(userId) if userId.present?

  end


  def rooms
    @rooms = Firestore::ChatRoom.find_by_uid(@user[:documentId]).sort_by { |h| h[:created_at].to_i }
    for room in @rooms
      userId = room[:members].keys.select { |v| v.to_s != @user[:documentId] }.first
      room[:user] = Firestore::LoginUser.find(userId) if userId.present?
    end
  end


  private

  def set_room
    @room = Firestore::ChatRoom.find(params[:id])
    p @room
  end


  def update_user_params
    params.require(:user_form).permit(:nickname, :profile_text, :status, :age, :sex, :prefecture_id)
  end

end
