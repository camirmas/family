defmodule SchedulerTest do
  use ExUnit.Case

  test "can create groups" do
    users = 1..100 |> Enum.map(fn i ->
      [i, "#{Enum.random(1..100)}", "#{Enum.random(1..100)}"] end)
    groups = Scheduler.Worker.make_schedule(users)

    assert length(groups) == 33
  end

  test "can handle small group sizes" do
    {:ok, groups} = Scheduler.schedule()

    assert length(groups) == 1
  end
end
