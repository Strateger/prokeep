defmodule ProkeepqWeb.Router do
  use ProkeepqWeb, :router

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

  scope "/", ProkeepqWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", ProkeepqWeb do
    pipe_through :api

    get "/receive-message/:queue/:message", ApiController, :receiveMessage
  end
end
