defmodule User.CSVTest do
  use ExUnit.Case

  test "can add users to csv" do
    {:ok, [_uuid, _first, _last]} = User.CSV.add_user("Chirrut", "Imwe", :write)
  end

  test "can get users from csv" do
    users = User.CSV.get_users()
    items = users |> Enum.to_list

    assert length(items) >= 1
  end
end
