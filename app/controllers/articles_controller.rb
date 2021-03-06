class ArticlesController < ApplicationController
  respond_to :html
  layout :layout_by_google_analytics
  before_action :authenticate_user!, :except => [:index, :show, :show_redirect, :show_all, :feed, :more]
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def index
    #TODO: make limit configurable || params[:limit]
    @articles = Article.by_published_at.descending.limit(5).skip(params[:skip].to_i)
  end

  def drafts
    #TODO: make limit configurable || params[:limit]
    @articles = Article.by_saved_at.descending.limit(10)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.create_by_user(params, current_user)
    respond_with(@article)
  end

  def edit
  end

  def update
    @article.update_attributes(params[:article])
    respond_with(@article)
  end

  def show
    redirect_to article_slug(@article) unless @article.is_draft

    @comments = Article.article_comments.
      startkey([@article.id]).
      endkey([@article.id, Time.now])
  end

  def show_all
    @articles = Article.articles_by_time_slug(params)

    if @articles.count == 1
      @article = @articles.first
      @comments = Article.article_comments.
        startkey([@article.id]).
        endkey([@article.id, Time.now])
    end

    render_404 if @article.blank? && @articles.blank?
  end

  def feed
    @articles = Article.by_published_at.descending.limit(5).all

    respond_to do |format|
      format.html do
        redirect_to feed_path(:format => :atom), :status => :moved_permanently
      end
      format.xml do
        redirect_to feed_path(:format => :atom), :status => :moved_permanently
      end
      format.atom
    end
  end

  private
    def set_article
      @article = Article.by_slug.key(params[:id]).first
    end
end
