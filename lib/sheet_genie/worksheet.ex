defmodule SheetGenie.Worksheet do
  def create_worksheet(sheet_name) do
    state_data = SheetGenie.Utils.read_state_file()
    current_workbook_path = state_data["current_workbook"]
    workbooks = state_data["workbooks"]

    updated_workbooks =
      Enum.map(workbooks, fn workbook ->
        if workbook["path"] == current_workbook_path do
          updated_sheets = [%{"name" => sheet_name, "rows" => []} | workbook["sheets"]]

          %{
            "path" => workbook["path"],
            "current_sheet" => sheet_name,
            "sheets" => updated_sheets
          }
        else
          workbook
        end
      end)

    updated_state = Map.put(state_data, "workbooks", updated_workbooks)
    SheetGenie.Utils.write_state_file(updated_state)

    current_workbook =
      Enum.find(updated_workbooks, fn workbook -> workbook["path"] == current_workbook_path end)

    SheetGenie.Workbook.update_excel_file(current_workbook_path, current_workbook)
    IO.puts("Worksheet #{sheet_name} added successfully.")
  end

  def open_worksheet(name) do
    name = SheetGenie.Utils.sanitize_name(name)
    state_data = SheetGenie.Utils.read_state_file()
    current_workbook_path = state_data["current_workbook"]

    updated_workbooks =
      Enum.map(state_data["workbooks"], fn workbook ->
        if workbook["path"] == current_workbook_path do
          Map.put(workbook, "current_sheet", name)
        else
          workbook
        end
      end)

    updated_state = Map.put(state_data, "workbooks", updated_workbooks)
    SheetGenie.Utils.write_state_file(updated_state)
  end

  def list_worksheet do
    state_data = SheetGenie.Utils.read_state_file()
    current_workbook_path = state_data["current_workbook"]

    current_workbook =
      Enum.find(state_data["workbooks"], fn workbook ->
        workbook["path"] == current_workbook_path
      end)

    if current_workbook do
      current_sheet_name = current_workbook["current_sheet"]

      current_sheet =
        Enum.find(current_workbook["sheets"], fn sheet ->
          sheet["name"] == current_sheet_name
        end)

      if current_sheet do
        IO.puts("Selected worksheet tab: #{current_sheet_name}")
        IO.puts("---")

        Enum.each(current_sheet["rows"], fn row ->
          IO.puts("#{Enum.join(row, ", ")}")
        end)
      else
        IO.puts("Current sheet not found.")
      end
    else
      IO.puts("Current workbook not found.")
    end
  end

  def append_to_current_worksheet(processed_data) do
    state_data = SheetGenie.Utils.read_state_file()
    current_workbook_path = state_data["current_workbook"]

    current_workbook =
      Enum.find(state_data["workbooks"], fn workbook ->
        workbook["path"] == current_workbook_path
      end)

    current_sheet_name = current_workbook["current_sheet"]

    append_mode = state_data["config"]["append_mode"]

    updated_sheets =
      Enum.map(current_workbook["sheets"], fn sheet ->
        if sheet["name"] == current_sheet_name do
          updated_rows =
            case append_mode do
              "columns" -> append_as_columns(sheet["rows"], processed_data)
              _ -> sheet["rows"] ++ processed_data
            end

          %{
            "name" => sheet["name"],
            "rows" => updated_rows
          }
        else
          sheet
        end
      end)

    updated_workbook = Map.put(current_workbook, "sheets", updated_sheets)

    updated_state =
      Map.update!(state_data, "workbooks", fn workbooks ->
        Enum.map(workbooks, fn workbook ->
          if workbook["path"] == current_workbook_path do
            updated_workbook
          else
            workbook
          end
        end)
      end)

    SheetGenie.Utils.write_state_file(updated_state)
    SheetGenie.Workbook.update_excel_file(current_workbook_path, updated_workbook)

    IO.puts("Data appended successfully to #{current_sheet_name}.")
  end

  defp append_as_columns(existing_rows, new_data) do
    max_length = max(length(existing_rows), length(new_data))

    # Ensure all rows have the same length
    padded_existing_rows = Enum.map(existing_rows, &pad_row(&1, max_length))
    padded_new_data = Enum.map(new_data, &pad_row(&1, max_length))

    Enum.zip(padded_existing_rows, padded_new_data)
    |> Enum.map(fn {row, new_cols} -> row ++ new_cols end)
  end

  defp pad_row(row, length) do
    row_length = length(row)

    if row_length < length do
      row ++ List.duplicate(nil, length - row_length)
    else
      row
    end
  end
end
