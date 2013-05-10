module MigrationGenerator
  def generate_migrations
    generate("migration", "add_skill_to_#{@model_name.pluralize} skill:float")
    generate("migration", "add_doubt_to_#{@model_name.pluralize} doubt:float")
    generate("migration", "add_wins_to_#{@model_name.pluralize} wins:integer")
    generate("migration", "add_losses_to_#{@model_name.pluralize} losses:integer")
    generate("migration", "add_draws_to_#{@model_name.pluralize} draws:integer")
  end

  def set_default_values
    # inject_into_file "db/migrations/add_skill_to_#{@model_name.pluralize}.rb", "config.gem :thor", :after => "Rails::Initializer.run do |config|\n"
  end
end