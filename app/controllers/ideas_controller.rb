class IdeasController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :find_user

  def index
    visible_ideas
    render 'user/show' if @user
  end

  def show
    @id = params[:id]
    visible_ideas
  end

  def new
    @idea = Idea.new
    @idea.user_id = @user.id
  end

  def edit
    @idea = Idea.find(params[:id])
    not_authorized unless current_user.id == @idea.created_by_id
  end

  def create
    @idea = Idea.new(idea_params)

    if @idea.save
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def update
    @idea = Idea.find(params[:id])

    if @idea.update(idea_params)
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy

    redirect_to user_path(@user)
  end

  private
    def idea_params
      params.require(:idea).permit(:name, :user_id, :created_by_id, :private)
    end

    def find_user
      @user = User.find(params[:user_id])
    end
end
