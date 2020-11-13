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
    |> validate_is_today(:date)
  end

  @doc false
  defp validate_is_today(changeset, field) do
    case changeset.valid? do
      true ->
        date = get_field(changeset, field)
        today = Date.utc_today
        case Date.compare(date, today) do
          :eq -> changeset
          _ -> add_error(changeset, :date, "La fecha es invalida")
        end
      _ ->
        changeset
    end
  end
end
