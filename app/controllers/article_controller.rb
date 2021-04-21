class ArticleController < ApplicationController
  def index
    @page = (params['page'] || 1).to_i

    firestore = Firestore::Base.client
    articles_ref = Firestore::Article.repo
    all_list   = Firestore::Article.all
    item_total = all_list.size
    page_ids   = all_list.map { |a| a[:documentId] }.each_slice(20).map { |n| n.first }

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
    article = Firestore::Article.find(document_id)
    query = articles_ref.where("created_at", '<=', article[:created_at]).order("created_at", "desc").limit(20)

    @articles = query.get
    #p @users.sort_by {|v| v.created_at }.sort.reverse
    #p @users.sort_by {|v| v.created_at }.map{|item| item[:nickname]}
    #p @users.sort_by {|v| v.created_at }.reverse.last

  end

  def show
  end

end
