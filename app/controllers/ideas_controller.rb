class IdeasController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :find_user

  def index
    visible_ideas
  end

  def show
    @id = params[:id]
    visible_ideas
  end

  def new
    @idea = Idea.new
  end

  def edit
    @idea = Idea.find(params[:id])
  end

  def create
    @idea = Idea.new(idea_params)

    if @idea.save
      redirect_to user_idea_path(@user, @idea)
    else
      render 'new'
    end
  end

  def update
    @idea = Idea.find(params[:id])

    if @idea.update(idea_params)
      redirect_to user_idea_path(@user, @idea)
    else
      render 'edit'
    end
  end

  def destroy
    @idea = Idea.find(params[:id])
    @idea.destroy

    redirect_to user_ideas_path(@user)
  end

  private
    def idea_params
      params.require(:idea).permit(:name, :created_by_id, :private)
    end

    def find_user
      @user = User.find(params[:user_id])
    end
end
