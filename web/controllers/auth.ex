defmodule Rumbl.Auth do
  @moduledoc """
  Authentication module plug
  """

  alias Rumbl.Router.Helpers
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller
  import Plug.Conn

  @doc """
  `init` is executed at compile time
  What this function returns is the second parameter to `call`
  """
  def init(options) do
    Keyword.fetch!(options, :repo)
  end

  @doc """
  `call` is executed at runtime
  Second parameter comes from `init`
  """
  def call(conn, repo) do
    user_id = get_session(conn, :user_id)

    # anything in conn.assigns is available in views with prefix @
    cond do
      conn.assigns[:current_user] ->
        conn
      user = user_id && repo.get(Rumbl.User, user_id) ->
        assign(conn, :current_user, user)  # puts in conn.assigns map
      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)  # this necessary?
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)  # sends cookie back with new identifier
  end

  def login_by_username_and_pass(conn, username, given_pass, options) do
    repo = Keyword.fetch!(options, :repo)
    user = repo.get_by(Rumbl.User, username: username)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()  # protection from timing attacks
        {:error, :user_not_found, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_user(conn, _options) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end
end
