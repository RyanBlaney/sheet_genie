defmodule SheetGenie.Utils do
  @state_file "config/state.json"

  def sanitize_name(name) do
    if String.ends_with?(name, ".xlsx") do
      String.trim_trailing(name, ".xlsx")
    else
      name
    end
  end

  def read_state_file do
    if File.exists?(@state_file) do
      File.read!(@state_file) |> Jason.decode!()
    else
      %{"workbooks" => []}
    end
  end

  def write_state_file(state_data) do
    File.write!(@state_file, Jason.encode!(state_data, pretty: true))
  end
end
