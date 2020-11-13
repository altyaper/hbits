defmodule HbitsWeb.PageController do
  use HbitsWeb, :controller
  alias Hbits.Habits

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    habits = Habits.list_habits_by_user(user_id)
    render(conn, "index.html", habits: habits)
  end
end
