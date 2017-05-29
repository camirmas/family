defmodule Api.FamilyFridayControllerTest do
  use Api.ConnCase

  @params %{"command" => "/fam-friday", "text" => ""}

  test "POST /friyay with no text returns a schedule", %{conn: conn} do
    conn = post conn, "/api/v1/friyay", @params

    # change this later once Scheduler is set up
    assert response(conn, 200) =~ "schedule will go here"
  end

  test "POST /friyay with proper text adds a user and returns a schedule",
    %{conn: conn} do
      params = %{@params | "text" => "add-fam Obi-Wan Kenobi"}
      conn = post conn, "/api/v1/friyay", params

      assert response(conn, 200) =~ "schedule will go here"
  end

  test "POST /friyay with improper text leads to an error message",
    %{conn: conn} do
      params = %{@params | "text" => "Obi-Wan Kenobi"}
      conn = post conn, "/api/v1/friyay", params

      assert response(conn, 200) =~ "Sorry, but your request was formatted incorrectly."
  end
end
