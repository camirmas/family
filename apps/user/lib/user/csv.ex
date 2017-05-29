defmodule User.CSV do

  @csv_path Application.get_env(:user, :csv_path)

  def add_user(first, last, mode \\ :append) do
    file = File.open!(@csv_path, [mode, :utf8])
    uuid = UUID.uuid4()
    data = [uuid, first, last]
    [data] |> CSV.encode |> Enum.each(&IO.write(file, &1))
    {:ok, data}
  end

  def get_users do
    File.stream!(@csv_path) |> CSV.decode!
  end
end
