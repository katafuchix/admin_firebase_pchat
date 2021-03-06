class SakuraController < ApplicationController
  before_action :set_user, only: [:show, :destroy, :edit, :update, :update_profile_image, :articles, :rooms]

  def index

    @page = (params['page'] || 1).to_i
    @nickname = params['nickname'] || ''

    users_ref  = Firestore::LoginUser.repo
    all_list   = Firestore::LoginUser.sakura(@nickname)
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
    #query = users_ref.where("created_at", '<=', user[:created_at]).order("created_at", "desc").limit(20)
    #@user = []

    if user.present?
      if @nickname.present?
        query = users_ref.where("nickname", '==', @nickname).where("created_at", '<=', user[:created_at]).order("created_at", "desc").limit(20)
        @users = query.get
      else
        query = users_ref.where("created_at", '<=', user[:created_at]).order("created_at", "desc").limit(20)
        @users = query.get
      end
    end

  end


  def show
  end


  def edit
    @post_user = UserForm.new
    @post_user.id = @user[:documentId]
  end


  def update
    params = update_user_params

    @post_user = UserForm.new
    @post_user.id             = @user[:documentId]
    @post_user.nickname       = params[:nickname]
    @post_user.profile_text   = params[:profile_text]
    @post_user.age            = params[:age]
    @post_user.sex            = params[:sex]
    @post_user.prefecture_id  = params[:prefecture_id]
    @post_user.status         = params[:status]

    Firestore::LoginUser.update(@post_user)
    flash[:notice] = '??????????????????'
    redirect_to action: :show, id: @user[:documentId]
  end


  # ??????????????????????????????????????????
  # PUT /users/1/update_profile_image
  def update_profile_image
    p params[:image]
    imageFile = params[:image]

    #file = bucket.create_file(imageFile.tempfile,"ProfilePhoto_test/1/avarar.jpg", acl: "public")
    file = Firestorage::ProfilePhoto.upload(imageFile)
    p 'file'
    p file

  end


  def articles
    @articles = Firestore::Article.find_by_uid(@user[:documentId])
  end


  def rooms
    @rooms = Firestore::ChatRoom.find_by_uid(@user[:documentId])
    @rooms = @rooms.sort_by { |h| h[:created_at] }.reverse
    for room in @rooms
      userId = room[:members].keys.select { |v| v.to_s != @user[:documentId] }.first
      room[:user] = Firestore::LoginUser.find(userId) if userId.present?
      room[:count] = Firestore::ChatRoom.messages(room[:documentId]).count
    end
  end


  # ????????????????????????
  def change_sakura
    user = Firestore::LoginUser.find(select_sakura_params[:id])
    if user.present?
      $sakura = user
      render json: user
      return
    end
    render json: false
  end

  private

  def select_sakura_params
    params.permit(:id)
  end

  def set_user
    @user = Firestore::LoginUser.find(params[:id])
    p @user
  end


  def update_user_params
    params.require(:user_form).permit(:nickname, :profile_text, :status, :age, :sex, :prefecture_id)
  end

end
