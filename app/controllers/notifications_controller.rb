class NotificationsController < ApplicationController
  before_action :require_login

  def mark_read
    notification = Notification.find(params[:id])
    if notification.user == current_user
      notification.update(read: true)
      redirect_back fallback_location: user_path(current_user), notice: "Notificación marcada como leída"
    else
      redirect_back fallback_location: root_path, alert: "No autorizado"
    end
  end

  private

  def require_login
    redirect_to login_path unless current_user
  end
end
