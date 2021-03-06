require "generators/sigma/model_updater"
require "generators/sigma/migration_generator"
require "generators/sigma/generator_instructions"

class SigmaGenerator < Rails::Generators::Base
  include MigrationGenerator, GeneratorInstructions, ModelUpdater

  source_root File.expand_path("../../templates", __FILE__)
  
  desc "Setup Sigma for some resource"

  def execute
    @model_name = ask("What is your resource model? (eg. user)")
    @scale      = ask("What will be the scale? (default is 50)").to_f
    @scale      = 50.0 if 0
    generate_migrations
    set_default_values
    creating_templates
    add_methods
    migrate
    instructions
  end
end