defmodule HbitsWeb.CalendarLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(HbitsWeb.HabitView, "calendar.html", assigns)
  end

  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, any}
  def mount(%{"hbit_id" => hbit_id}, user, socket) do
    calendar = get_calendar
    if connected?(socket), do: Process.send_after(self(), :update, 30000)
    {:ok, assign(socket, :calendar, calendar)}
  end

  def get_calendar() do
    current_year = DateTime.utc_now |> Map.fetch!(:year)
    months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    Stream.with_index(months, 1) |>
      Enum.reduce(%{}, fn ({k, v}, acc) ->
        days_in_month = :calendar.last_day_of_the_month(current_year, v)
        Map.put(acc, v, %{:days => days_in_month, :name => k, :month_index => v})
      end)
  end



  @spec handle_event(<<_::104>>, any, any) :: {:noreply, any}
  def handle_event("selected_date", %{"day" => day, "month" => month}, socket) do
    current_year = DateTime.utc_now |> Map.fetch!(:year)
    date = Date.from_iso8601!("#{current_year}-#{String.pad_leading(month, 2, "0")}-#{String.pad_leading(day, 2, "0")}")
    IO.inspect(date)
    {:noreply, socket}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 30000)
    {:noreply, socket}
  end

end
