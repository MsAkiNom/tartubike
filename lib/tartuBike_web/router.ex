defmodule TartuBikeWeb.Router do
  use TartuBikeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TartuBikeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    #plug TartuBike.Authentication, repo: TartuBike.Repo
  end

  pipeline :browser_auth do
    plug TartuBike.AuthPipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TartuBikeWeb do
    pipe_through :browser

    resources "/sessions", SessionController, only: [:new, :create, :delete ]
  end

  scope "/", TartuBikeWeb do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
    resources "/users", UserController
    get "/popular", RouteController, :index
    get "/search", SearchController, :index
    post "/search", SearchController, :nearby
    post "/search/nearme", SearchController, :nearme
    get "/search/:station_id/show-bikes", SearchController, :showBikes
  end

  scope "/", TartuBikeWeb do
    pipe_through [:browser, :browser_auth, :ensure_auth]

    resources "/memberships", MembershipController

    get "/rent", BikeController, :rent
    post "/rent", BikeController, :rentit
    get "/book", BikeController, :book
    post "/book", BikeController, :bookit
    get "/end", BikeController, :end_ride
    post "/endit", BikeController, :endit
    resources "/reports", ReportController
    get "/usersummary", UsersummaryController, :usersummary
    get "/userusage", UsersummaryController, :userusage
    get "/ridehistory", UsersummaryController, :ridehistory
    get "/invoicehistory", UsersummaryController, :invoicehistory

    # Utility for add balance and payment
    get "/paymentservice/addBalance", PaymentserviceController, :index
    post "/paymentservice/addBalance", PaymentserviceController, :addBalance
    get "/paymentservice/issue", PaymentserviceController, :issue
    post "/paymentservice/issue", PaymentserviceController, :issueCheck
    post "/paymentservice/issuePay", PaymentserviceController, :issuePay

    get "/invoice", InvoiceController, :invoice
    get "/reciept", RecieptController, :reciept
    post "/invoicesuccess", InvoiceController, :successinvoice

  end

  # Other scopes may use custom stacks.
  # scope "/api", TartuBikeWeb do
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
      live_dashboard "/dashboard", metrics: TartuBikeWeb.Telemetry
    end
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
