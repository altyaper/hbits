defmodule HbitsWeb.CalendarLive do
  use Phoenix.LiveView

  alias Hbits.Dates
  alias Hbits.Habits

  def render(assigns) do
    Phoenix.View.render(HbitsWeb.HabitView, "calendar.html", assigns)
  end

  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, any}
  def mount(%{"hbit_id" => hbit_id}, user, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 30000)
    habit = Habits.get_habit!(hbit_id)
    matrix = Map.fetch!(habit, :calendar_dates)
      |> get_matrix_calendar()
    {:ok, socket
      |> assign(:calendar, get_calendar())
      |> assign(:habit, habit)
      |> assign(:matrix, matrix)

    }
  end

  defp get_matrix_calendar(calendar_dates) do
    calendar_dates |> clean_calendar_dates() |> get_dates_map()
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

  defp clean_calendar_dates(calendar_dates) do
    calendar_dates
      |> Enum.map(fn cd ->
          cd.date
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

  @spec handle_event(<<_::104>>, any, any) :: {:noreply, any}
  def handle_event("selected_date", %{"day" => day, "month" => month, "habit-id" => habit_id}, socket) do
    current_year = DateTime.utc_now |> Map.fetch!(:year)
    date = Date.from_iso8601!("#{current_year}-#{String.pad_leading(month, 2, "0")}-#{String.pad_leading(day, 2, "0")}")
    date_params = %{:habit_id => habit_id, :date => date}
    case Dates.create_habit(date_params) do
      {:ok, date} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket}
    end

  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 30000)
    {:noreply, socket}
  end

end
