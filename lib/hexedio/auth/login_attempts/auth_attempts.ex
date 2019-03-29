defmodule Hexedio.LoginAttempt do
  use Agent
  alias Hexedio.Auth

  @doc """
  Starts the LoginAttempt agent to keep track of login attempts
  """
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Get the number of attempts by a username
  """
  def get(username) do
    Agent.get(__MODULE__, &Map.get(&1, username))
  end

  @doc """
  Adds or increments user when a login attempt is made
  """
  def make(username) do
    case Auth.get_user(username) do
      nil -> {:error, "Incorrect username or password"}
      %Auth.User{} -> get(username) |> update(username)
    end
  end

  defp update(nil, username) do 
    Agent.update(
      __MODULE__, 
      &Map.put(&1, username, {1, expiry_date()})
    )
  end

  defp update(attempts, username) do 
    Agent.update(
      __MODULE__, 
      &Map.put(&1, username, set_attempt(attempts))
    )
  end

  defp set_attempt({attempts, %DateTime{} = expiry}) do
    case DateTime.compare(expiry, current_time()) do
      :lt -> {1, expiry_date()}
      :gt -> {attempts + 1, expiry_date()}
    end
  end

  defp current_time do
    {_, datetime} = DateTime.now("Etc/UTC")
    datetime
  end

  defp expiry_date do
    DateTime.now("Etc/UTC")
    |> elem(1)
    # Add 15 minutes to the current date
    |> DateTime.add(20, :second)
  end
end
