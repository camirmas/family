defmodule Api.FamilyFridayController do
  @moduledoc """
  This module is responsible for handling slash commands sent from Slack
  """
  use Api.Web, :controller

  @doc """
  Handles the command that checks the schedule
  """
  def create(conn, %{"command" => "/fam-friday", "text" => text}) do
    text
    |> handle_request()
    |> send_response(conn)
  end

  defp handle_request("") do
    # Simply return the existing schedule
    schedule = Scheduler.get_schedule()

    {:ok, schedule}
  end

  defp handle_request("schedule") do
    Scheduler.schedule()
  end

  defp handle_request(name) do
    # Add a new person to the group if the formatting is correct, and reschedule
    # to include that person
    [head|tail] = String.split(name, " ")

    case head do
      "add-fam" when not is_nil(tail) ->
        {:ok, _user_id} = User.create_user(tail)
        Scheduler.schedule()
      _ ->
        :error
    end
  end

  defp send_response({:ok, schedule}, conn) do
    # Returns a formatted schedule
    groups =
      Enum.map(schedule, fn group ->
        group = Enum.map(group, fn {_uuid, first, last} -> "| #{first} #{last} " end)
        group ++ ["\n"]
      end)

    conn |> send_resp(200, groups)
  end

  defp send_response(:error, conn) do
    conn |> send_resp(200, "Sorry, but your request was formatted incorrectly.")
  end
end
