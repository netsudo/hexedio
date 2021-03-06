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

  @doc """
  Resets the user attempts back to 0
  """
  def reset(username) do
    Agent.update(
      __MODULE__, 
      &Map.delete(&1, username)
    )
    :reset
  end

  defp update(nil, username) do 
    Agent.update(
      __MODULE__, 
      &Map.put(&1, username, {1, expiry_date()})
    )
  end

  defp update(attempts = {i,_}, username) when i < 5 do 
    Agent.update(
      __MODULE__, 
      &Map.put(&1, username, set_attempt(attempts))
    )
  end

  defp update({i, %DateTime{} = expiry}, username) when i == 5 do 
    case DateTime.compare(expiry, current_time()) do
      :lt ->
        Agent.update(
          __MODULE__, 
          &Map.put(&1, username, {5, expiry_date()})
        )
      :gt -> 
        {:error, "Login limit exceeded"}
    end
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
    |> DateTime.add(15*60, :second)
  end
end
