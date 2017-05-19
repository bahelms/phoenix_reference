defmodule Rumbl.Permalink do
  @moduledoc """
  Custom type for handling user friendly resource names for videos.
  EG: 45-awesome-show represents the video with id 45.
  """

  @behaviour Ecto.Type

  @doc """
  Returns underlying Ecto type.
  """
  def type, do: :id

  @doc """
  Called when external data is casted by Ecto in queries and changesets.
  """
  def cast(binary) when is_binary(binary) do
    case Integer.parse(binary) do
      {int, _} when int > 0 -> {:ok, int}
      _ -> :error
    end
  end
  def cast(integer) when is_integer(integer) do
    {:ok, integer}
  end
  def cast(_), do: :error

  @doc """
  Called when data is sent to the database. Struct -> db format conversion.
  """
  def dump(integer) when is_integer(integer) do
    {:ok, integer}
  end

  @doc """
  Called when data is loaded from the database. db format -> Struct conversion.
  """
  def load(integer) when is_integer(integer) do
    {:ok, integer}
  end
end
