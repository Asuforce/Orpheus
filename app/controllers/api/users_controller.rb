class Api::UsersController < Api::ApplicationController
  before_action :auth_user, only: [:index, :update, :destroy, :following, :followers]
  before_action :correct_user, only: :update
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = current_user
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    user = User.new(user_params)
    if user.save
      user.send_activation_email
      render json: user, status: :created
    else
      render json: user.errors.messages, status: :unprocessable_entity
    end
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors.messages, status: :unprocessable_entity
    end
  end

  def destroy
    User.find_by(id: params[:id]).try(:destroy)
    render nothing: :true, status: :ok
  end

  def following
    @title = "Following"
    @user = current_user
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = current_user
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = current_user
      render nothing: :true, status: :bad_request unless current_user?(@user)
    end

    def admin_user
      render nothing: :true, status: :bad_request unless current_user.admin?
    end

    def auth_user
      auth_key = request.authorization
      token = auth_key.split("  ").last
      decode_token = User.decode_jwt(token)
    end
end
