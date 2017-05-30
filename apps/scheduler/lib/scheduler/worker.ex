defmodule Scheduler.Worker do
  use GenServer

  # API

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Creates a new schedule.
  """
  def schedule do
    GenServer.call(__MODULE__, :schedule)
  end

  @doc """
  Retrieves the existing schedule.
  """
  def get_schedule do
    GenServer.call(__MODULE__, :get_schedule)
  end

  # Callbacks

  def init(_) do
    users = User.get_users()
    groups = make_schedule(users)

    {:ok, %{groups: groups}}
  end

  def handle_call(:schedule, _from, state) do
    users = User.get_users()
    new_groups = make_schedule(users)

    {:reply, {:ok, new_groups}, %{state | groups: new_groups}}
  end

  def handle_call(:get_schedule, _from, %{groups: groups} = state) do
    {:reply, groups, state}
  end

  # Helper functions

  def make_schedule(users) when length(users) < 5, do: [users]
  def make_schedule(users) do
    users = Enum.shuffle(users)
    num_users = length(users)
    group_sizes = 3..5 |> Enum.to_list

    num_users
    |> find_groups(group_sizes)
    |> form_groups(users)
  end

  defp find_groups(num_people, group_sizes, acc \\ [])
  defp find_groups(0, _group_sizes, acc), do: acc
  defp find_groups(_num_people, [], acc), do: acc
  defp find_groups(num_people, group_sizes, acc) when num_people > 0 do
    lowest_size = Enum.at(group_sizes, 0)

    case lowest_size <= num_people do
      true ->
        find_groups(num_people - lowest_size, group_sizes, acc ++ [lowest_size])
      _ ->
        adjust_groups(num_people, group_sizes, acc, 0)
    end
  end

  defp adjust_groups(0, _group_sizes, acc, _index), do: acc
  defp adjust_groups(num_people, group_sizes, acc, index) do
    case Enum.at(acc, index) < List.last(group_sizes) do
      true ->
        adjust_groups(num_people - 1, group_sizes, List.update_at(acc, index, &(&1 + 1)), index)
      _ ->
        adjust_groups(num_people, group_sizes, acc, index + 1)
    end
  end

  defp form_groups(group_sizes, users, groups \\ [])
  defp form_groups([], [], groups), do: groups
  defp form_groups([head|tail], users, groups) do
    group =  Enum.take(users, head)

    form_groups(tail, users -- group, groups ++ [group])
  end
end
