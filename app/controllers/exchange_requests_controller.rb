class ExchangeRequestsController < ApplicationController
  before_action :require_login

  def create
    book = Book.find(params[:book_id])
    exchange_request = ExchangeRequest.new(
      sender: current_user,
      receiver: book.user,
      book: book,
      status: "pending"
    )

    if exchange_request.save
      # Crear notificación interna para el dueño del libro
      Notification.create(
        user: exchange_request.receiver,
        message: "#{exchange_request.sender.name} ha solicitado intercambiar el libro '#{exchange_request.book.title}' contigo.",
        read: false
      )

      redirect_to book_path(book), notice: "¡Solicitud de intercambio enviada correctamente!"
    else
      redirect_to book_path(book), alert: "No se pudo enviar la solicitud. Inténtalo nuevamente."
    end
  end

  def index
    @received = current_user.received_requests.includes(:book, :sender)
    @sent = current_user.sent_requests.includes(:book, :receiver)
  end

  def update
    request = ExchangeRequest.find(params[:id])
    if request.receiver == current_user
      request.update(status: params[:status])
      redirect_to exchange_requests_path, notice: "Solicitud #{params[:status]}"
    else
      redirect_to root_path, alert: "No autorizado"
    end
  end

  private

  def require_login
    redirect_to login_path unless current_user
  end
end
