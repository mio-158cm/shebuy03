class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i(show destroy)
  def new
    @post = Post.new
    @post.photos.build
  end

  def create
    @post = Post.new(post_params)
    if @post.photos.present?
      @post.save
      redirect_to root_path
      flash[:notice] = "投稿完了！"
    else
      redirect_to root_path
      flash[:alert] = "もう１回投稿してください"
    end
  end

  def index
    @posts = Post.limit(10).includes(:photos, :user).order('created_at DESC')
  end

  def show
  end

  def destroy
    if @post.user == current_user
      flash[:notice] = "投稿を消しました" if @post.destroy
    else
      flash[:alert] = "もう１回削除してください"
    end
    redirect_to root_path
  end


  private
    def post_params
      params.require(:post).permit(:caption, photos_attributes: [:image]).merge(user_id: current_user.id)
    end

    def set_post
      @post = Post.find_by(id: params[:id])
    end
end
