defmodule Hexedio.Mailer do
  use Bamboo.Mailer, otp_app: :hexedio
end

defmodule Hexedio.Email do
  import Bamboo.Email

  def contact_email(contact_params) do
    new_email(
      to: "____",
      from: "____",
      subject: contact_params["subject"],
      text_body: "Sender: #{contact_params["email"]}\n\n 
                          #{contact_params["body"]}\n"
    )
  end
end
