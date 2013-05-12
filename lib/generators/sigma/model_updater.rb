module ModelUpdater
  def add_methods
    resource = File.read find_in_source_paths("resource_model.rb")
    inject_into_file  "app/models/#{@model_name}.rb",
                          "\n#{resource}\n",
                          :after => ":float"

    inject_into_class "app/models/#{@model_name}.rb", @model_name.capitalize, "\n#{resource}\n"
  end
end