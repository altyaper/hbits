defmodule HbitsWeb.Pow.Mailer do
  @config domain: Application.get_env(:hbits, :mailgun_domain),
          key: Application.get_env(:hbits, :mailgun_key)
  use Mailgun.Client, @config
  use Pow.Phoenix.Mailer
  require Logger

  @impl true
  def cast(%{user: user, subject: subject, text: text, html: html}) do
    send_email to: user.email, from: "local@host.com", subject: subject, text: text
  end

  @impl true
  def process(email) do
    # Send email
    IO.inspect(email)
    IO.puts "Soooooooooooooooooooomething"
    Logger.debug("E-mail sent: #{inspect email}")
  end
end
