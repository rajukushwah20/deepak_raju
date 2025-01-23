class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_comment, only: %i[show update destroy]

  def create
    comment = Comment.new(comment_params)
    if comment.save
      render json: comment, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    comments = Comment.all
    if comments.any?
      render json: comments, status: :ok
    else
      render json: { errors: 'No comments found' }, status: :not_found
    end
  end

  def show
    if @comment
      render json: @comment, status: :ok
    else
      render json: { errors: 'Comment not found' }, status: :not_found
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment, status: :ok
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.destroy
      render json: { message: 'Comment deleted successfully!' }, status: :ok
    else
      render json: { errors: 'Failed to delete comment' }, status: :unprocessable_entity
    end
  end

  private

  def set_comment
    @comment = Comment.find_by(id: params[:id])
    render json: { errors: 'Comment not found' }, status: :not_found unless @comment
  end

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end
end
