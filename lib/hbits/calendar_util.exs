defmodule Hbits.Util.DateUtil do

  def get_matrix do
    months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    current_year = DateTime.utc_now |> Map.fetch!(:year)
    Stream.with_index(months, 1)
      |> Enum.reduce(%{}, fn ({month_name, index}, acc) ->
          days_in_month = :calendar.last_day_of_the_month(current_year, index)
          Map.put(acc, index, %{
            :days => get_map_from_month(index),
            :days_size => days_in_month,
            :name => month_name,
            :month_index => index
          })
        end)
  end

  defp get_dates_map(dates) do
    {_mapped, final} = dates |> Enum.map_reduce(%{}, fn date, acc ->
      case Map.fetch(acc, date.month) do
        {:ok, list} ->
          ls = list ++ [date.day] |> Enum.uniq |> Enum.sort
          {date,  Map.put(acc, date.month, ls)}
        :error ->
          {date,  Map.put(acc, date.month, [date.day])}
      end
    end)
    final
  end

  def matrix_with_classes(matrix, dates_list) do
    map = dates_list |> get_dates_map
    matrix
    |> add_classes(map)

  end

  def add_classes(matrix, map) do
    matrix
    |> add_today_class
    |> add_selected_class(map)
  end

  def add_today_class(matrix) do
    current_date = DateTime.utc_now
    current_month = current_date |> Map.fetch!(:month)
    current_day = current_date |> Map.fetch!(:day)
    put_in(matrix[current_month][:days][current_day], [ "class-item__today" | matrix[current_month][:days][current_day]])
  end


  def add_selected_class(matrix, map) do
    Enum.reduce(map, matrix, fn {month_index, month_days}, acc ->
      Enum.reduce(month_days, acc, fn day_index, _inner_acc ->
        put_in(acc[month_index][:days][day_index], ["class-item__selected" | matrix[month_index][:days][day_index]])
      end)
    end)
  end

  def get_map_from_month(index) do
    current_year = DateTime.utc_now |> Map.fetch!(:year)
    days_in_month = :calendar.last_day_of_the_month(current_year, index)
    Enum.reduce(1..days_in_month, %{}, fn index, acc ->
      Map.put(acc, index, [])
    end)
  end

end

# test = [~D[2020-01-01], ~D[2020-01-03], ~D[2020-01-02], ~D[2020-01-04], ~D[2020-10-26],
#     ~D[2020-01-01], ~D[2020-01-05], ~D[2020-07-05], ~D[2020-07-05], ~D[2020-12-01]]

# Hbits.DateUtil.get_matrix |> Hbits.DateUtil.matrix_with_classes(test) |> IO.inspect
