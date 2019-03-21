defmodule Hexedio.LoginAttempt do
  use GenServer

  @doc """
  Starts the LoginAttempt agent to keep track of login attempts
  """
  def start_link do
    GenServer.start_link(__MODULE__, :empty, name: __MODULE__)
  end

  def init(:empty), do: {:ok, %{}}

  @doc """
  Get the number of attempts by a username
  """
  def get(username) do
    GenServer.call(__MODULE__, {:lookup, username})
  end

  @doc """
  Adds or increments user when a login attempt is made
  """
  def make(username) do
    GenServer.call(__MODULE__, {:update, username})
  end

  @doc """
  Removes the user from the agent so it can be restarted cleanly
  """
  def start_timer(username) do
    receive do
    after
      6_000 -> GenServer.call(__MODULE__, {:stop, "Timer ended.", 0})
    end
  end

  def handle_call({:lookup, username}, _from, index_map) do
    {:reply, get_user_attempts(username, index_map), index_map}
  end

  def handle_call({:update, username}, _from, index_map) do 
    tracked_user? = Map.has_key?(index_map, username)
    {:reply, :ok, increment_or_create(username, index_map, tracked_user?)}
  end

  defp increment_or_create(username, index_map, _tracked_user = true) do
    Map.update!(index_map, username, &(&1 + 1))
  end

  defp increment_or_create(username, index_map, _tracked_user = false) do
    Map.put(index_map, username, 1)
  end

  defp get_user_attempts(username, index_map) do
    case Map.get(index_map, username) do
      nil          -> {:error, :not_found}
      _ = attempts -> {:ok, attempts}
    end
  end

end
