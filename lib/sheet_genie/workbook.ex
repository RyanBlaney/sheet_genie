defmodule SheetGenie.Workbook do
  def create_workbook(name) do
    name = SheetGenie.Utils.sanitize_name(name)
    file_path = "#{name}.xlsx"

    create_excel_file(file_path)

    state_data = SheetGenie.Utils.read_state_file()

    new_workbook = %{
      "path" => file_path,
      "current_sheet" => "Sheet1",
      "sheets" => [%{"name" => "Sheet1", "rows" => []}]
    }

    updated_workbooks = state_data["workbooks"] ++ [new_workbook]

    updated_state =
      state_data
      |> Map.put("current_workbook", file_path)
      |> Map.put("workbooks", updated_workbooks)

    SheetGenie.Utils.write_state_file(updated_state)
    IO.puts("Workbook created successfully at #{file_path}.")
  end

  def open_workbook(name) do
    name = SheetGenie.Utils.sanitize_name(name)
    state_data = SheetGenie.Utils.read_state_file()
    workbook_path = "#{name}.xlsx"

    workbook = Enum.find(state_data["workbooks"], fn wb -> wb["path"] == workbook_path end)

    if workbook do
      updated_state = Map.put(state_data, "current_workbook", workbook_path)
      SheetGenie.Utils.write_state_file(updated_state)

      IO.puts(
        "Workbook '#{name}.xlsx' opened successfully with sheets: #{Enum.map(workbook["sheets"], fn sheet -> sheet["name"] end) |> Enum.join(", ")}"
      )

      {:ok, workbook["sheets"]}
    else
      IO.puts("Workbook '#{name}.xlsx' not found in the current state.")
      {:error, :not_found}
    end
  end

  def create_excel_file(file_path) do
    sheet = %Elixlsx.Sheet{name: "Sheet1", rows: []}
    workbook = %Elixlsx.Workbook{sheets: [sheet]}

    case Elixlsx.write_to(workbook, file_path) do
      {:ok, _} -> IO.puts("Excel file created successfully at #{file_path}")
      {:error, reason} -> IO.puts("Failed to create Excel file: #{reason}")
    end
  end

  def list_workbook do
    state_data = SheetGenie.Utils.read_state_file()

    Enum.each(state_data["workbooks"], fn workbook ->
      IO.puts("Workbook path: #{workbook["path"]}")
      IO.puts("Current sheet: #{workbook["current_sheet"]}")

      IO.puts(
        "Sheets: #{Enum.map(workbook["sheets"], fn sheet -> sheet["name"] end) |> Enum.join(", ")}"
      )

      IO.puts("---")
    end)
  end

  def update_excel_file(current_workbook_path, updated_workbook) do
    elixlsx_sheets =
      Enum.map(updated_workbook["sheets"], fn sheet ->
        %Elixlsx.Sheet{name: sheet["name"], rows: sheet["rows"]}
      end)

    elixlsx_workbook = %Elixlsx.Workbook{sheets: elixlsx_sheets}

    case Elixlsx.write_to(elixlsx_workbook, current_workbook_path) do
      {:ok, _} -> IO.puts("Excel file updated successfully at #{current_workbook_path}.")
      {:error, reason} -> IO.puts("Failed to update Excel file: #{reason}")
    end
  end
end
