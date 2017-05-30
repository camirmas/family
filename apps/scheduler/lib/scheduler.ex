defmodule Scheduler do
  @moduledoc """
  Documentation for Scheduler.
  """

  @doc """
  Creates a new schedule.
  """
  def schedule do
    Scheduler.Worker.schedule()
  end


  @doc """
  Gets an existing schedule.
  """
  def get_schedule do
    Scheduler.Worker.get_schedule()
  end
end
