defmodule FactionWeb.Router do
  use FactionWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword, PowEmailConfirmation]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FactionWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Pow.Plug.Session, otp_app: :faction
  end

  pipeline :browser_protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug FactionWeb.APIAuthPlug, otp_app: :faction
  end


  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: Faction.APIAuthErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()
  end

  # Unprotected routes
  scope "/", FactionWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Auth protected routes
  scope "/", FactionWeb do
    pipe_through [:browser, :browser_protected]
  end

  # Other scopes may use custom stacks.
  # scope "/api", FactionWeb do
  #   pipe_through :api
  # end

  scope "/api/v1", FactionWeb.API.V1, as: :api_v1 do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
  end

  scope "/api/v1", FactionWeb.API.V1, as: :api_v1 do
    pipe_through [:api, :api_protected]

    # Your protected API endpoints here
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
