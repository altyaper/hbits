defmodule HbitsWeb.PageController do
  use HbitsWeb, :controller

  alias Hbits.Habits

  def index(conn, _params) do
    habits = Habits.list_habits()
    render(conn, "index.html", habits: habits)
  end
end
