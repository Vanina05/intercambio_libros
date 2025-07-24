class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to books_path, notice: "Cuenta creada correctamente"
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @notifications = @user.notifications.order(created_at: :desc)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to @user, notice: "Perfil actualizado"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :city, :description)
  end
end
