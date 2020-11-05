defmodule HbitsWeb.CalendarLive do
  use Phoenix.LiveView

  alias Hbits.Dates
  alias Hbits.Habits
  alias Hbits.Util.DateUtil

  require IEx;

  def render(assigns) do
    Phoenix.View.render(HbitsWeb.HabitView, "calendar.html", assigns)
  end

  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, any}
  def mount(%{"hbit_id" => hbit_id}, user, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 30000)
    habit = Habits.get_habit!(hbit_id)
    dates = Map.fetch!(habit, :calendar_dates)
      |> get_matrix_calendar()
    matrix = get_matrix |> matrix_with_classes(dates)
    {:ok, socket
      |> assign(:calendar, get_calendar())
      |> assign(:habit, habit)
      |> assign(:matrix, matrix)
    }
  end


  @spec handle_event(<<_::104>>, any, any) :: {:noreply, any}
  def handle_event("selected_date", %{"day" => day, "month" => month, "habit-id" => habit_id}, socket) do
    current_year = DateTime.utc_now |> Map.fetch!(:year)
    date = Date.from_iso8601!("#{current_year}-#{String.pad_leading(month, 2, "0")}-#{String.pad_leading(day, 2, "0")}")
    date_params = %{:habit_id => habit_id, :date => date}
    case Dates.create_date(date_params) do
      {:ok, date} ->
        habit = Habits.get_habit!(habit_id)
        dates = Map.fetch!(habit, :calendar_dates)
          |> get_matrix_calendar
        matrix = get_matrix |> matrix_with_classes(dates)
        {:noreply, assign(socket, :matrix, matrix)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket}
    end
  end

  @spec handle_info(:done | :update, any) :: {:noreply, any}
  def handle_info(:done, socket) do
    IO.inspect("DOOOONE")
    {:noreply, socket}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 30000)
    {:noreply, socket}
  end


  defp get_matrix_calendar(calendar_dates) do
    calendar_dates |> clean_calendar_dates() |> get_dates_map()
  end

  defp clean_calendar_dates(calendar_dates) do
    calendar_dates
      |> Enum.map(fn cd ->
          cd.date
      end)
  end

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

  defp get_calendar() do
    current_year = DateTime.utc_now |> Map.fetch!(:year)
    months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    Stream.with_index(months, 1) |>
      Enum.reduce(%{}, fn ({k, v}, acc) ->
        days_in_month = :calendar.last_day_of_the_month(current_year, v)
        Map.put(acc, v, %{:days => days_in_month, :name => k, :month_index => v})
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

  def matrix_with_classes(matrix, map) do
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
    put_in(matrix[current_month][:days][current_day], [ "calendar_item__today" | matrix[current_month][:days][current_day]])
  end


  def add_selected_class(matrix, map) do
    map
    |> Enum.reduce(matrix, fn {month_index, days_list}, outer_acc_matrix ->
      days_list
        |> Enum.reduce(outer_acc_matrix, fn day_index, inner_acc_matrix ->
          put_in(inner_acc_matrix, [month_index, :days, day_index], ["calendar_item__selected"] ++ get_in(inner_acc_matrix, [month_index, :days, day_index]))
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
