defmodule Hbits.Repo do
  use Ecto.Repo,
    otp_app: :hbits,
    adapter: Ecto.Adapters.Postgres
end
