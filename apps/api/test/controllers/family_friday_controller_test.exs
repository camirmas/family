defmodule Api.FamilyFridayControllerTest do
  use Api.ConnCase

  @params %{"command" => "/fam-friday", "text" => ""}

  setup context do
    # overwrites existing entries in test csv
    on_exit fn ->
      User.CSV.add_user("Master", "Yoda", :write)
    end

    context
  end

  test "POST /friyay with no text returns a schedule", %{conn: conn} do
    conn = post conn, "/api/v1/friyay", @params

    # change this later once Scheduler is set up
    assert response(conn, 200) =~ "|"
  end

  test "POST /friyay with proper text adds a user and returns a schedule",
    %{conn: conn} do
      params = %{@params | "text" => "add-fam Obi-Wan Kenobi"}
      conn = post conn, "/api/v1/friyay", params
      users = User.get_users() |> Enum.map(fn {_uuid, _first, last} -> last end)

      assert "Kenobi" in users
      assert response(conn, 200) =~ "|"
  end

  test "POST /friyay with improper text leads to an error message",
    %{conn: conn} do
      params = %{@params | "text" => "Obi-Wan Kenobi"}
      conn = post conn, "/api/v1/friyay", params

      assert response(conn, 200) =~ "Sorry, but your request was formatted incorrectly."
  end

  test "POST /friyay with 'schedule' command creates a new schedule", %{conn: conn} do
    params = %{@params | "text" => "schedule"}

    conn = post conn, "/api/v1/friyay", params

    assert response(conn, 200) =~ "|"
  end
end
