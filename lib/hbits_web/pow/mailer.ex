defmodule HbitsWeb.Pow.Mailer do
  @config domain: Application.get_env(:hbits, :mailgun_domain),
          key: Application.get_env(:hbits, :mailgun_key)
  use Mailgun.Client, @config
  use Pow.Phoenix.Mailer
  require Logger

  @from Application.get_env(:hbits, :mailgun_from)

  @impl true
  def cast(%{user: user, subject: subject, text: text, html: html}) do
    send_email to: user.email, from: @from, subject: subject, text: text
  end

  @impl true
  def process(email) do
    # Send email
    Logger.debug("E-mail sent: #{inspect email}")
  end
end
