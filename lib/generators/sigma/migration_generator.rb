module MigrationGenerator
  def generate_migrations
    generate("migration", "add_skill_to_#{@model_name.pluralize} skill:float")
    generate("migration", "add_doubt_to_#{@model_name.pluralize} doubt:float")
    generate("migration", "add_wins_to_#{@model_name.pluralize} wins:integer")
    generate("migration", "add_losses_to_#{@model_name.pluralize} losses:integer")
    generate("migration", "add_draws_to_#{@model_name.pluralize} draws:integer")
    generate("migration", "add_expectations_to_#{@model_name.pluralize} expectations:string")
  end

  def set_default_values
    migrations = Dir.entries("db/migrate")
    expectations = { 'win_expectation'=> { 'wins' => 0,'losses' => 0,'draws' => 0 },'lost_expectation'=> { 'wins' => 0,'losses' => 0,'draws' => 0 },'draw_expectation'=> { 'wins' => 0,'losses' => 0,'draws' => 0 } }    
    migrations.each do |m|
      name = m.split(/^[0-9]+_/)[1]
      if name == "add_skill_to_#{@model_name.pluralize}.rb"
        update_migration(m, @scale/2, ":float")
      elsif name == "add_doubt_to_#{@model_name.pluralize}.rb"
        update_migration(m, @scale/6, ":float")
      elsif name == "add_expectations_to_#{@model_name.pluralize}.rb"
        update_migration(m, expectations, ":string")
      elsif name == "add_wins_to_#{@model_name.pluralize}.rb" || name == "add_losses_to_#{@model_name.pluralize}.rb" || name == "add_draws_to_#{@model_name.pluralize}.rb"
        update_migration(m, 0, ":integer")
      end
    end
  end

  def migrate
    puts <<-EOS

=======================================
> Running rake db:migrate
=======================================

    EOS
    rake("db:migrate")
  end

  private

  def update_migration (file, default, after)
    inject_into_file  "db/migrate/#{file}", ", :default => #{default}", :after => "#{after}"
  end
end