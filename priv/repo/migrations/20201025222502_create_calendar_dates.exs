defmodule Hbits.Repo.Migrations.CreateCalendarDates do
  use Ecto.Migration

  def change do
    create table(:calendar_dates) do
      add :date, :date
      add :habit_id, references(:habits, on_delete: :nothing)

      timestamps()
    end

  end
end
