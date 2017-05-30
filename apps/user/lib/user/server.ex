defmodule User.Server do
  use GenServer

  # API

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Adds a new user to the ETS table.
  """
  def add_user(user_data) do
    GenServer.call(__MODULE__, {:add_user, user_data})
  end

  @doc """
  Retrieves existing users from the ETS table.
  """
  def get_users() do
    GenServer.call(__MODULE__, :get_users)
  end

  # Callbacks

  def init(_) do
    users = :ets.new(:users, [])
    populate_users_table(users)

    {:ok, %{users: users}}
  end

  def handle_call({:add_user, user_data}, _from, %{users: users} = state) do
    insert_user(users, user_data)

    {:reply, :ok, state}
  end

  def handle_call(:get_users, _from, %{users: users} = state) do
    {:reply, :ets.tab2list(users), state}
  end

  # Private

  defp populate_users_table(users) do
    User.CSV.get_users()
    |> Enum.map(&insert_user(users, &1))
  end

  defp insert_user(users, user_data) do
    user_data = List.to_tuple(user_data)
    :ets.insert(users, user_data)
  end
end
