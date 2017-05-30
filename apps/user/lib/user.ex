defmodule User do
  @moduledoc """
  This application provides a simple User management system that is
  tied to a given CSV filepath.
  """

  @doc """
  Creates a new user.
  """
  def create_user([first|last] = name) do
    User.Worker.create_user(first, last)
  end

  def create_user(_name), do: :error

  @doc """
  Retrieves existing users.
  """
  def get_users do
    User.Worker.get_users()
  end
end
