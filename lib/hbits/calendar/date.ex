defmodule Hbits.Calendar.Date do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hbits.Habits.Habit

  schema "calendar_dates" do
    field :date, :date
    belongs_to :habit, Habit

    timestamps()
  end

  @doc false
  def changeset(date, attrs) do
    date
    |> cast(attrs, [:date, :habit_id])
    |> validate_required([:date, :habit_id])
  end
end
