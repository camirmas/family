defmodule UserTest do
  use ExUnit.Case

  setup context do
    # overwrites existing entries in test csv
    on_exit fn ->
      User.CSV.add_user("Master", "Yoda", :write)
    end

    context
  end

  describe "User" do
    test "can create a user" do
      assert {:ok, _user} = User.create_user(["Sheev", "Palpatine"])
    end

    test "can get users" do
      users = User.get_users()

      assert length(users) >= 1
    end
  end
end
