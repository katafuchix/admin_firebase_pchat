class IndexController < ApplicationController
  before_action :set_user, only: [:show, :destroy, :edit, :update,]

  def index
    @page = (params['page'] || 1).to_i

    firestore = Firestore::Base.client

    users_ref  = Firestore::LoginUser.repo
    all_list   = Firestore::LoginUser.all
    item_total = all_list.size
    page_ids   = all_list.map { |user| user[:documentId] }.each_slice(20).map { |n| n.first }
    #p page_ids

    all_page = (item_total / 20).ceil

    @max_page = all_page
    @current = @page
    @pagination = {}
    @pagination['最初'] = 1 if @current >= 3
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
    @pagination['最後'] = @max_page if @current <= @max_page - 3

    c_page = @page - 1
    document_id = page_ids[c_page]
    user = Firestore::LoginUser.find(document_id)
    query = users_ref.where("created_at", '<=', user[:created_at]).order("created_at", "desc").limit(20)

    @users = query.get
    #p @users.sort_by {|v| v.created_at }.sort.reverse
    #p @users.sort_by {|v| v.created_at }.map{|item| item[:nickname]}
    #p @users.sort_by {|v| v.created_at }.reverse.last
    @last_user = @users.sort_by {|v| v.created_at }.reverse.last
  end

  def show
  end

  def edit
    @post_user = UserForm.new
    @post_user.id = @user[:documentId]
    p @post_user
  end

  def update
    p = update_user_params
    p update_user_params

    #flash[:notice] = 'プロフィールを更新しました。'
    redirect_back(fallback_location: index_index_path)
  end

  private

  def set_user
    @user = Firestore::LoginUser.find(params[:id])
    p @user
  end

  def update_user_params
    params.require(:user_form).permit(:nickname, :profile_text)
  end

end
