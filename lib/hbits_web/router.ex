defmodule HbitsWeb.Router do
  use HbitsWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router,
  extensions: [PowResetPassword, PowEmailConfirmation]
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :liveview do
    plug :put_root_layout, {HbitsWeb.LayoutView, :app}
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser
    pow_routes
    pow_extension_routes
  end

  scope "/", HbitsWeb do
    pipe_through [:browser, :protected]
    resources "/habits", HabitController
    get "/", PageController, :index
  end

  scope "/", HbitsWeb do
    pipe_through [:browser, :protected, :liveview]
    resources "/habits", HbitController, only: [:show] do
      live "calendar", CalendarLive
    end
  end


  # Other scopes may use custom stacks.
  # scope "/api", HbitsWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HbitsWeb.Telemetry
    end
  end
end
