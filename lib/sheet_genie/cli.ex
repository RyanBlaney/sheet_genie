defmodule SheetGenie.CLI do
  @moduledoc """
  Command line interface for SheetGenie
  """

  @new ["new", "create"]
  @worksheet ["worksheet", "ws"]
  @workbook ["workbook", "wb"]
  @select ["open", "select"]
  @add ["append", "add"]
  @list ["list", "show"]

  def main(args) do
    args
    |> parse_args()
    |> process_command()
  end

  defp parse_args(args) do
    OptionParser.parse(args, switches: [])
  end

  defp process_command({_opts, [new, name], _}) when new in @new do
    IO.puts("Creating new project: #{name}")
    SheetGenie.create_project(name)
  end

  defp process_command({_opts, [ws, new, name], _}) when ws in @worksheet and new in @new do
    IO.puts("Creating new worksheet tab: #{name}")
    SheetGenie.create_worksheet(name)
  end

  defp process_command({_opts, [wb, new, name], _}) when wb in @workbook and new in @new do
    IO.puts("Creating new workbook: #{name}")
    SheetGenie.create_workbook(name)
  end

  defp process_command({_opts, [wb, open, name], _}) when wb in @workbook and open in @select do
    IO.puts("Selected workbook: #{name}")
    SheetGenie.open_workbook(name)
  end

  defp process_command({_opts, [ws, open, name], _}) when ws in @worksheet and open in @select do
    IO.puts("Selected worksheet tab: #{name}")
    SheetGenie.open_worksheet(name)
  end

  defp process_command({_opts, [ws, list], _}) when ws in @worksheet and list in @list do
    SheetGenie.list_worksheet()
  end

  defp process_command({_opts, [wb, list], _}) when wb in @workbook and list in @list do
    SheetGenie.list_workbook()
  end

  defp process_command({_opts, [add, "api", api_url | rest], _}) when add in @add do
    schema = List.first(rest) || "default_schema"
    IO.puts("Appending data from API: #{api_url} with schema: #{schema}")
    SheetGenie.append_api(api_url, schema)
  end

  defp process_command({_opts, ["schema", new, name | schema], _}) when new in @new do
    IO.puts("Creating a new schema: #{name} with schema: #{Enum.join(schema, ", ")}")
    SheetGenie.create_schema(name, schema)
  end

  defp process_command(_other) do
    IO.puts("""
    Usage:
      sheet-genie new [NAME]                  - to generate a new project and opens the default sheet 1
      sheet-genie worksheet new [NAME]        - to generate a new worksheet tab
      sheet-genie worksheet open [NAME]       - to open a worksheet tab
      sheet-genie append api [API_URL] [SCHEMA] - sends an API get request to the URL and appends it to the excel sheet on the current worksheet
      sheet-genie schema new [NAME] [API SCHEMA...] - generates a .json config file in the project directory at ./config/ with the API SCHEMA
    """)
  end
end
