class SessionsController < ApplicationController
  def new
  end

  def create
    # Validar que email y password no estén vacíos
    if params[:email].blank? || params[:password].blank?
      flash.now[:alert] = "Debes completar todos los campos."
      return render :new
    end

    # Buscar usuario
    user = User.find_by(email: params[:email])

    # Validar existencia y contraseña
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Has iniciado sesión correctamente."
    else
      flash.now[:alert] = "Correo o contraseña incorrectos."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Has cerrado sesión."
  end
end
