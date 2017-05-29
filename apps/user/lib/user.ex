defmodule User do
  @moduledoc """
  This application provides a simple User management system that is
  tied to a given CSV filepath.
  """

  @doc """
  Creates a new User and adds it to the CSV and to an ETS table.
  """
  def create_user([first|last] = name) do
    User.Worker.create_user(first, last)
  end

  def create(name) do
    :error
  end

  def get_users do
    User.Worker.get_users()
  end
end
