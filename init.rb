begin
  require File.join(File.dirname(__FILE__), 'lib', 'sigma')
rescue LoadError
  begin
    require 'sigma'
  rescue LoadError => e
    raise e unless defined?(Rake) &&
      (Rake.application.top_level_tasks.include?('gems') ||
        Rake.application.top_level_tasks.include?('gems:install'))
  end
end