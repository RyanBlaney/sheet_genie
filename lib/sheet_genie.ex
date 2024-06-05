defmodule SheetGenie do
  @moduledoc """
  Documentation for `SheetGenie`.
  """

  defdelegate create_project(name), to: SheetGenie.Project
  defdelegate create_workbook(name), to: SheetGenie.Workbook
  defdelegate open_workbook(name), to: SheetGenie.Workbook
  defdelegate create_worksheet(sheet_name), to: SheetGenie.Worksheet
  defdelegate open_worksheet(name), to: SheetGenie.Worksheet
  defdelegate list_worksheet(), to: SheetGenie.Worksheet
  defdelegate list_workbook(), to: SheetGenie.Workbook
  defdelegate create_schema(name, schema), to: SheetGenie.Schema
  defdelegate append_api(url, schema_name), to: SheetGenie.Schema
end
