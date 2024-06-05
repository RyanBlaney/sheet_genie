defmodule SheetGenie.Project do
  @state_file "config/state.json"

  def create_project(name) do
    name = SheetGenie.Utils.sanitize_name(name)

    File.mkdir_p!(name)
    File.mkdir_p!(Path.join(name, "config"))
    SheetGenie.Workbook.create_excel_file(Path.join(name, "#{name}.xlsx"))

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
end
