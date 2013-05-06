Gem::Specification.new do |s|
  s.name        = 'sigma'
  s.version     = File.read(File.dirname(__FILE__) + '/VERSION').strip
  s.date        = '2013-05-06'
  s.summary     = "A ranking algorithm implementation for Ruby on Rails applications."
  s.description = ""
  s.authors     = ["João Moura"]
  s.email       = 'joaomdmoura@gmail.com'
  s.files       = Dir[ 'lib/*', 'lib/**/*', 'lib/**/**/*', 'init.rb' ]
  s.homepage    = 'http://joaomdmoura.github.com/sigma/'
end
