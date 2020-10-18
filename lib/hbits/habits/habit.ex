defmodule Hbits.Habits.Habit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "habits" do
    field :color, :string
    field :icon, :string
    field :name, :string
    field :user_id, :id
    belongs_to :users, User

    timestamps()
  end

  @doc false
  def changeset(habit, attrs) do
    habit
    |> cast(attrs, [:name, :icon, :color])
    |> validate_required([:name, :icon, :color])
  end
end
