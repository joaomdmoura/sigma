require "generators/musigma/generator_instructions"

class Musigma
  class SetupGenerator < Rails::Generators::Base
    include GeneratorInstructions

    source_root File.expand_path("../../templates", __FILE__)
    
    desc "Setup Mu-Sigma for some resource"

    def execute
      @model_name = ask("What is your resource model? (eg. user)")
      instructions
    end
  
  end
end