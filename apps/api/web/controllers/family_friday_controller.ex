defmodule Api.FamilyFridayController do
  @moduledoc """
  This module is responsible for handling slash commands sent from Slack
  """
  use Api.Web, :controller

  @doc """
  Handles the command that checks the schedule
  """
  def create(conn, %{"command" => "/fam-friday", "text" => text} = req) do
    text
    |> handle_request()
    |> send_response(conn)
  end

  defp handle_request("") do
    # Simply return the existing schedule
    #Scheduler.get_schedule()
    {:ok, %{}}
  end

  defp handle_request(name) do
    # Add a new person to the group if the formatting is correct, and reschedule
    # to include that person
    [head|tail] = String.split(name, " ")

    case head do
      "add-fam" when not is_nil(tail) ->
        #{:ok, _user_id} = User.create(tail)
        #Scheduler.schedule()
        {:ok, %{}}
      _ ->
        :error
    end
  end

  defp send_response({:ok, schedule}, conn) do
    # Returns the proper schedule
    conn |> send_resp(200, "schedule will go here")
  end

  defp send_response(:error, conn) do
    # Returns the proper schedule
    conn |> send_resp(200, "Sorry, but your request was formatted incorrectly.")
  end
end
