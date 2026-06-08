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
    # Ordenamos recibidas: Primero 'pending', luego las demás, y dentro de eso, la más nueva arriba
    @received = current_user.received_requests
                            .includes(:book, :sender)
                            .in_order_of(:status, %w[pending accepted rejected])
                            .order(created_at: :desc)

    # Ordenamos enviadas: Simplemente la más nueva arriba
    @sent = current_user.sent_requests
                        .includes(:book, :receiver)
                        .order(created_at: :desc)
  end

  def update
    @request = ExchangeRequest.find(params[:id])

    if @request.receiver == current_user
      status = params[:exchange_request][:status]
      message = params[:exchange_request][:response_message]

      if @request.update(status: status, response_message: message)
        if status == "accepted"
          # Enviar correo electrónico
          UserMailer.exchange_accepted(@request).deliver_now
          notice_msg = "Solicitud aceptada y correo enviado."
        elsif status == "rejected"
          # Crear notificación interna
          Notification.create(
            user: @request.sender,
            message: "#{current_user.name} ha rechazado tu solicitud por '#{@request.book.title}'. Motivo: #{message}",
            read: false
          )
          notice_msg = "Solicitud rechazada correctamente."
        end
        redirect_to exchange_requests_path, notice: notice_msg
      else
        redirect_to exchange_requests_path, alert: "Error al procesar la solicitud."
      end
    else
      redirect_to root_path, alert: "No autorizado"
    end
  end

  private

  def require_login
    redirect_to login_path unless current_user
  end
end
