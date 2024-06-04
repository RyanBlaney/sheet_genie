defmodule SheetGenie do
  @moduledoc """
  Documentation for `SheetGenie`.
  """

  @state_file "config/state.json"
  @schema_file "config/schemas.json"

  def create_project(name) do
    name = sanitize_name(name)

    File.mkdir_p!(name)
    File.mkdir_p!(Path.join(name, "config"))
    create_excel_file(Path.join(name, "#{name}.xlsx"))

    IO.puts(
      "Project #{name} created successfully!\n\nTo start modifying the project, do \n$ cd #{name}"
    )

    config_file = Path.join(name, @state_file)

    state_data = %{
      "current_workbook" => "#{name}.xlsx",
      "workbooks" => [
        %{
          "path" => "#{name}.xlsx",
          "current_sheet" => "Sheet1",
          "sheets" => [%{"name" => "Sheet1", "rows" => []}]
        }
      ]
    }

    File.write!(config_file, Jason.encode!(state_data, pretty: true))
  end

  def create_excel_file(file_path) do
    sheet = %Elixlsx.Sheet{name: "Sheet1", rows: []}
    workbook = %Elixlsx.Workbook{sheets: [sheet]}

    case Elixlsx.write_to(workbook, file_path) do
      {:ok, _} -> IO.puts("Excel file created successfully at #{file_path}")
      {:error, reason} -> IO.puts("Failed to create Excel file: #{reason}")
    end
  end

  def create_worksheet(sheet_name) do
    state_data = read_state_file()
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
    write_state_file(updated_state)

    current_workbook =
      Enum.find(updated_workbooks, fn workbook -> workbook["path"] == current_workbook_path end)

    update_excel_file(current_workbook_path, current_workbook)
    IO.puts("Worksheet #{sheet_name} added successfully.")
  end

  def create_workbook(name) do
    name = sanitize_name(name)
    file_path = "#{name}.xlsx"

    create_excel_file(file_path)

    state_data = read_state_file()

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

    write_state_file(updated_state)
    IO.puts("Workbook created successfully at #{file_path}.")
  end

  def open_workbook(name) do
    name = sanitize_name(name)
    state_data = read_state_file()
    workbook_path = "#{name}.xlsx"

    workbook = Enum.find(state_data["workbooks"], fn wb -> wb["path"] == workbook_path end)

    if workbook do
      updated_state = Map.put(state_data, "current_workbook", workbook_path)
      write_state_file(updated_state)

      IO.puts(
        "Workbook '#{name}.xlsx' opened successfully with sheets: #{Enum.map(workbook["sheets"], fn sheet -> sheet["name"] end) |> Enum.join(", ")}"
      )

      {:ok, workbook["sheets"]}
    else
      IO.puts("Workbook '#{name}.xlsx' not found in the current state.")
      {:error, :not_found}
    end
  end

  def open_worksheet(name) do
    name = sanitize_name(name)
    state_data = read_state_file()
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
    write_state_file(updated_state)
  end

  def list_worksheet do
    state_data = read_state_file()
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

  def list_workbook do
    state_data = read_state_file()

    Enum.each(state_data["workbooks"], fn workbook ->
      IO.puts("Workbook path: #{workbook["path"]}")
      IO.puts("Current sheet: #{workbook["current_sheet"]}")

      IO.puts(
        "Sheets: #{Enum.map(workbook["sheets"], fn sheet -> sheet["name"] end) |> Enum.join(", ")}"
      )

      IO.puts("---")
    end)
  end

  def create_schema(name, schema) do
    schemas =
      if File.exists?(@schema_file) do
        File.read!(@schema_file) |> Jason.decode!()
      else
        %{}
      end

    # Add the new schema
    new_schema = %{
      "name" => name,
      "schema" => schema,
      "formatting" => %{}
    }

    updated_schemas = Map.put(schemas, name, new_schema)

    # Write the updated schemas to the file
    File.write!(@schema_file, Jason.encode!(updated_schemas, pretty: true))
    IO.puts("Schema #{name} created successfully in #{@schema_file}.")

    # Update the state file to set the current schema
    state_data =
      if File.exists?(@state_file) do
        File.read!(@state_file) |> Jason.decode!()
      else
        %{}
      end

    updated_state = Map.put(state_data, "current_schema", name)
    File.write!(@state_file, updated_state |> Jason.encode!(pretty: true))
    IO.puts("State updated with current schema: #{name}.")
  end

  def append_api(url, schema_name) do
    IO.puts("Appending data from API: #{url} with schema: #{schema_name}")

    # Load schema
    schemas = File.read!(@schema_file) |> Jason.decode!()
    schema = Map.get(schemas, schema_name)

    if schema == nil do
      IO.puts("Schema #{schema_name} not found in #{@schema_file}.")
      :ok
    else
      # Fetch data from API
      response = HTTPoison.get!(url)
      data = Jason.decode!(response.body)

      # Process data according to schema
      processed_data = process_data(data["data"], schema["schema"])

      # Append data to current worksheet
      append_to_current_worksheet(processed_data)
    end
  end

  defp process_data(data, schema) do
    Enum.map(data, fn item ->
      Enum.map(schema, fn field ->
        [key, _type] = String.split(field, ":")
        Map.get(item, key)
      end)
    end)
  end

  def append_to_current_worksheet(processed_data) do
    state_data = read_state_file()
    current_workbook_path = state_data["current_workbook"]

    current_workbook =
      Enum.find(state_data["workbooks"], fn workbook ->
        workbook["path"] == current_workbook_path
      end)

    current_sheet_name = current_workbook["current_sheet"]

    updated_sheets =
      Enum.map(current_workbook["sheets"], fn sheet ->
        if sheet["name"] == current_sheet_name do
          %{
            "name" => sheet["name"],
            "rows" => sheet["rows"] ++ processed_data
          }
        else
          sheet
        end
      end)

    updated_workbook = Map.put(current_workbook, "sheets", updated_sheets)

    updated_state =
      Map.put(
        state_data,
        "workbooks",
        Enum.map(state_data["workbooks"], fn workbook ->
          if workbook["path"] == current_workbook_path do
            updated_workbook
          else
            workbook
          end
        end)
      )

    write_state_file(updated_state)
    update_excel_file(current_workbook_path, updated_workbook)
    IO.puts("Data appended successfully to #{current_sheet_name}.")
  end

  defp sanitize_name(name) do
    if String.ends_with?(name, ".xlsx") do
      String.trim_trailing(name, ".xlsx")
    else
      name
    end
  end

  defp read_state_file do
    if File.exists?(@state_file) do
      File.read!(@state_file) |> Jason.decode!()
    else
      %{"workbooks" => []}
    end
  end

  defp write_state_file(state_data) do
    File.write!(@state_file, Jason.encode!(state_data, pretty: true))
  end

  defp update_excel_file(current_workbook_path, updated_workbook) do
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
