defmodule Hbits.Habits.Habit do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hbits.Users.User

  schema "habits" do
    field :color, :string
    field :icon, :string
    field :name, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(habit, attrs) do
    habit
    |> cast(attrs, [:name, :icon, :color])
    |> validate_required([:name, :icon, :color])
  end
end
