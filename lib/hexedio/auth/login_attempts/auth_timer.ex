defmodule Hexedio.AttemptTimer do
  use GenServer
  alias Hexedio.LoginAttempt

  def start_link(username) do
    username = String.to_atom(username)
    GenServer.start_link(__MODULE__, :timer, name: username)
  end

  def init(:timer) do
    timer = Process.send_after(self(), :clear, 10_000)
    {:ok, %{timer: timer}}
  end

  def handle_call(:reset_timer, _from, %{timer: timer}) do
    Process.cancel_timer(timer)
    timer = Process.send_after(self(), :clear, 10_000)
    {:reply, :ok, %{timer: timer}}
  end

  def handle_info(:clear, state) do
    username = process_name
    LoginAttempt.reset(username)
    {:stop, :normal, state}
  end

  defp process_name do
    Process.info(self)
    |> List.keyfind(:registered_name, 0)
    |> elem(1)
    |> Atom.to_string
  end
end
