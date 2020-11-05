defmodule HbitsWeb.HabitView do
  use HbitsWeb, :view

  def get_extra_classes(month_index, day, matrix) do
    []
      |> has_been_selected(month_index, day, matrix)
      |> is_today(month_index, day)
      |> is_past(month_index, day)
      |> Enum.join(" ")
  end

  def has_been_selected(classess, month_index, day, matrix) do
    case Map.fetch(matrix, month_index) do
      {:ok, list} ->
        list
          |> Enum.member?(day)
          |> prepend_if_true(classess, ["calendar_item__selected"])
      :error -> classess
    end
  end

  def is_today(classess, month_index, day_index) do
    today = Date.utc_today
    day = today.day
    month = today.month
    flag = month == month_index && day == day_index
    prepend_if_true(flag, classess, ["calendar_item__today"])
  end

  def is_past(classess, month_index, day_index) do
    date = Date.from_iso8601!("2020-#{String.pad_leading(Integer.to_string(month_index), 2, "0")}-#{String.pad_leading(Integer.to_string(day_index), 2, "0")}")
    today = Date.utc_today
    if (date < today), do: classess ++ ["calendar_item__past"], else: classess
  end

  defp prepend_if_true(flag, list, extra) do
    if flag, do: extra ++ list, else: list
  end
end
