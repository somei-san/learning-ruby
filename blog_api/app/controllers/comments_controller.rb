class CommentsController < ApplicationController
  before_action :set_post

  # GET /posts/:post_id/comments
  def index
    @comments = @post.comments
    render json: @comments
  end

  # POST /posts/:post_id/comments
  def create
    @comment = @post.comments.new(comment_params)

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_content
    end
  end

  private
    def set_post
      @post = Post.find(params[:post_id])
    end

    def comment_params
      params.expect(comment: [ :body, :user_id ])
    end
end
