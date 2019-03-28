defmodule Hexedio.LoginAttempt do
  use Agent

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
    get(username) |> update(username)
  end

  defp update(nil, username) do 
    Agent.update(__MODULE__, 
                 &Map.put(&1, username, {1, expiry_date()}))
  end

  defp update(attempts, username) when is_integer(attempts) do 
    Agent.update(__MODULE__, 
                 &Map.put(&1, username, attempts + 1))
  end

  defp update(%DateTime{} = expiry, username) do
    cond do
      expiry <= current_time() -> IO.puts "Reset attempts"
      expiry >  current_time() -> IO.puts "Add new attempt"
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
