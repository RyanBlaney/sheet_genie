defmodule SheetGenie.Schema do
  @schema_file "config/schemas.json"

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
    state_data = SheetGenie.Utils.read_state_file()

    updated_state = Map.put(state_data, "current_schema", name)
    SheetGenie.Utils.write_state_file(updated_state)
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
      SheetGenie.Worksheet.append_to_current_worksheet(processed_data)
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
end
