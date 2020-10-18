defmodule Hbits.Repo.Migrations.CreateHabits do
  use Ecto.Migration

  def change do
    create table(:habits) do
      add :name, :string
      add :icon, :string
      add :color, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:habits, [:user_id])
  end
end
