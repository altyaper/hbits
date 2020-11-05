defmodule Hbits.Dates do
  @moduledoc """
  The Habits context.
  """

  import Ecto.Query, warn: false
  alias Hbits.Repo

  alias Hbits.Calendar.Date

  def list_dates do
    Repo.all(Date)
  end

  def get_date!(id), do: Repo.get!(Date, id)

  def create_date(attrs \\ %{}) do
    %Date{}
    |> Date.changeset(attrs)
    |> Repo.insert()
  end

end
