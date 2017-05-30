defmodule User.Worker do
  use GenServer

  # API

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Creates a new user, adding that user to the CSV as well
  as updating the ETS table in User.Server.
  """
  def create_user(first, last) do
    GenServer.call(__MODULE__, {:create_user, first, last})
  end

  @doc """
  Retrieves existing users from User.Server.
  """
  def get_users do
    GenServer.call(__MODULE__, :get_users)
  end

  # Callbacks

  def handle_call({:create_user, first, last}, _from, state) do
    last = Enum.at(last, 0)
    resp = {:ok, user} = User.CSV.add_user(first, last)
    User.Server.add_user(user)

    {:reply, resp, state}
  end

  def handle_call(:get_users, _from, state) do
    {:reply, User.Server.get_users, state}
  end
end
