# encoding: utf-8
class PostsController < ApplicationController
  layout :choose_layout

  def index
    @top_active_class = "blog"
    collection
    respond_to { |format| format.html }
  end

  def show
    @top_active_class = "blog"
    resource
    respond_to { |format| format.html }
  end

  def post_per_category
    collection
    respond_to do |format|
      format.html { render :index }
    end
  end

  def feed
    max_age = 4.hours
    response.headers['Cache-Control'] = 'public, max-age=' + max_age.to_i.to_s
    response.headers['Expires'] = max_age.from_now.httpdate
    response.content_type = 'application/atom+xml'
    fresh_when :last_modified => Post.feed_last_modified
  end

  protected

  def resource
    @action = 'show'
    @resource ||= Post.find(params[:id])
  end
  # helper_method :resource

  def collection
    @action = 'index'
    @collection ||= begin
      posts = if params.include?(:category)
                Post.find_by_category(params[:category])
              else
                Post.where(params.slice(:year, :month, :day))
              end
      posts = Kaminari.paginate_array(posts).page(params[:page]).per(posts_per_page)
      posts
    end
  end
  # helper_method :collection

  private

  def posts_per_page
    params[:count] || Postmarkdown::Config.options[:posts_per_page]
  end

  def choose_layout
    if Postmarkdown::Config.options[:use_theme]
      ActiveSupport::Deprecation.warn "`Postmarkdown::Config.options[:use_theme]` is deprecated. Use `Postmarkdown::Config.options[:layout] = 'postmarkdown'` instead."
      'postmarkdown'
    else
      Postmarkdown::Config.options[:layout]
    end
  end
end
