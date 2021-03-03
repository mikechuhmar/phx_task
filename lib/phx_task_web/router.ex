defmodule PhxTaskWeb.Router do
  use PhxTaskWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end



  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug PhxTask.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", PhxTaskWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", PhxTaskWeb do
    pipe_through [:api, :auth]

    get "/users_list", UserController, :index
    post "/sign_up", UserController, :sign_up
    get "/get_user", UserController, :show
    post "/sign_in", UserController, :sign_in
    post "/sign_in_by_token", UserController, :sign_in_by_token
    # get "/some_action", UserController, :some_action

  end

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
      live_dashboard "/dashboard", metrics: PhxTaskWeb.Telemetry
    end
  end
end
