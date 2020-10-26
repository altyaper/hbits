defmodule Hbits.Habits.Habit do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hbits.Users.User
  alias Hbits.Calendar.Date

  schema "habits" do
    field :color, :string
    field :icon, :string
    field :name, :string
    belongs_to :user, User
    has_many :calendar_dates, Date

    timestamps()
  end

  @doc false
  def changeset(habit, attrs) do
    habit
    |> cast(attrs, [:name, :icon, :color])
    |> validate_required([:name, :icon, :color])
  end
end
