defmodule Rumbl.UserController do
  use Rumbl.Web, :controller
  alias Rumbl.User

  # Each plug checks for conn.halted == true
  plug :authenticate_user when action in [:index, :show]

  def index(conn, _params) do
    users = Repo.all(User)
    render conn, :index, users: users
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, :new, changeset: changeset
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render conn, :show, user: user
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Rumbl.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render conn, :new, changeset: changeset
    end
  end
end
