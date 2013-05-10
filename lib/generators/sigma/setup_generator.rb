require "generators/sigma/migration_generator"
require "generators/sigma/generator_instructions"

class Sigma
  class SetupGenerator < Rails::Generators::Base
    include MigrationGenerator
    include GeneratorInstructions

    source_root File.expand_path("../../templates", __FILE__)
    
    desc "Setup Sigma for some resource"

    def execute
      @model_name = ask("What is your resource model? (eg. user)")
      @scale      = ask("What will be the scale? (eg. 50)").to_i
      generate_migrations
      set_default_values
      instructions
    end
  
  end
end