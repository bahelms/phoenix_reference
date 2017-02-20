defmodule Rumbl.UserRepoTest do
  @moduledoc """
  This module tests side effects of the User model
  """

  use Rumbl.ModelCase
  alias Rumbl.User

  @valid_attrs %{name: "A User", username: "eva"}

  test "converts unique_constraint on username to error" do
    insert_user(username: "eric")
    attrs = Map.put(@valid_attrs, :username, "eric")
    changeset = User.changeset(%User{}, attrs)

    assert {:error, changeset} = Repo.insert(changeset)
		{error, _} = changeset.errors[:username]
    assert "has already been taken" == error
  end
end
