class PostsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_post, only: [:show, :update, :destroy, :post_comments]

  def create
    post = Post.new(post_params)
    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors }, status: :unprocessable_entity
    end
  end

  def index
    posts = Post.all
    if posts.present?
      render json: posts, status: :ok
    else
      render json: { errors: "Posts not found" }, status: :not_found
    end
  end

  def show
    render json: @post, status: :ok
  end

  def update
    if @post.update(post_params)
      render json: @post, status: :ok
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    render json: { message: "Post deleted successfully!" }, status: :ok
  end

  def post_comments
    comments = @post.comments
    render json: { 
      post: @post, 
      comments_count: comments.count, 
      comments: comments 
    }, status: :ok
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])
    render json: { errors: "Post not found" }, status: :not_found unless @post
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
