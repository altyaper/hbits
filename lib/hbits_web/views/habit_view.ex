defmodule HbitsWeb.HabitView do
  use HbitsWeb, :view

  def has_been_selected(month_index, day, matrix) do
    case Map.fetch(matrix, month_index) do
      {:ok, list} ->
        list |> Enum.member?(day)
      :error -> false
    end
  end
end
