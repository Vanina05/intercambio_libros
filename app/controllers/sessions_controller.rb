class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to books_path, notice: "Sesión iniciada"
    else
      flash.now[:alert] = "Correo o contraseña incorrectos"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Sesión cerrada"
  end
end
