class UserMailer < ApplicationMailer
  def exchange_accepted(exchange_request)
    @exchange_request = exchange_request
    @sender = exchange_request.sender
    @receiver = exchange_request.receiver
    @book = exchange_request.book
    @message = exchange_request.response_message

    mail(to: @sender.email, subject: "¡Tu solicitud de intercambio ha sido aceptada!")
  end
end
