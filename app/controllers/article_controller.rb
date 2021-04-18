class ArticleController < ApplicationController
  def index
    @page = (params['page'] || 1).to_i
    @created_at = params['created_at'] || ''
    @document_id = params['document_id'] || ''

    firestore = Firestore::Base.client
    articles_ref = Firestore::Article.repo

    item_total =  Firestore::Article.all.size #users_ref.get.map{|item| item[:id]}.size

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

    if @document_id != ''
      p '@document_id'
      p @document_id
      article = Firestore::Article.find(@document_id)
      p article
      query = articles_ref.where("created_at", '<', article[:created_at]).order("created_at", "desc").limit(20)
    else
      query = articles_ref.order("created_at", "desc").limit(20) #.where "id", "=", 1
    end

    #query.get do |city|
    #  puts "#{city.document_id} data: #{city.data}."
    #end

    @articles = query.get
    #p @users.sort_by {|v| v.created_at }.sort.reverse
    #p @users.sort_by {|v| v.created_at }.map{|item| item[:nickname]}
    #p @users.sort_by {|v| v.created_at }.reverse.last
    @last_article = @articles.sort_by {|v| v.created_at }.reverse.last
  end

  def show
  end
  
end
