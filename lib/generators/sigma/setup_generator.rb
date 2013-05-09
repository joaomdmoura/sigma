require "generators/sigma/model_generator"
require "generators/sigma/generator_instructions"

class Sigma
  class SetupGenerator < Rails::Generators::Base
    include ModelGenerator
    include GeneratorInstructions

    source_root File.expand_path("../../templates", __FILE__)
    
    desc "Setup Sigma for some resource"

    def execute
      @model_name = ask("What is your resource model? (eg. user)")
      @scale      = ask("What is the scale that you want? (eg. 50)")
      generate_models
      instructions
    end
  
  end
end