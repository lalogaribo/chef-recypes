class CommentsController < ApplicationController
  before_action :require_user, only: [:create]
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.build(comment_params)
    @comment.chef = current_chef
    if @comment.save
      flash[:success] = "Comment was created"
      redirect_to recipe_path(@recipe)
    else
      flash[:danger] = "Comment was not created"
      redirect_to recipe_path(@recipe)
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:description)
  end
end