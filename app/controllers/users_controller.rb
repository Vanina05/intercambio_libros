class UsersController < ApplicationController
  # Agregamos esto para no repetir User.find en cada método
  before_action :set_user, only: [ :show, :edit, :update ]

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

    if @user == current_user
      # Solo el dueño ve sus notificaciones
      @notifications = @user.notifications.order(created_at: :desc)
    else
      @notifications = [] # No mostrar nada si es otro usuario
    end

    if @user == current_user
      # 1. Contamos todas las no leídas para el badge (el círculo rojo)
      @unread_count = @user.notifications.where(read: false).count

      # 2. Obtenemos todas las que no han sido leídas
      unread_notifications = @user.notifications.where(read: false).order(created_at: :desc)

      # 3. Obtenemos solo las últimas 5 que ya fueron leídas
      recent_read_notifications = @user.notifications.where(read: true).order(created_at: :desc).limit(5)

      # 4. Combinamos ambas listas (primero las no leídas, luego las 5 leídas)
      @notifications = unread_notifications + recent_read_notifications
    else
      @notifications = []
      @unread_count = 0
    end
  end

  def edit
    # Verificamos que el usuario solo pueda editar su propio perfil
    unless @user == current_user
      redirect_to root_path, alert: "No tienes permiso para editar este perfil."
    end
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

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Usuario no encontrado"
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :city, :description)
  end
end
