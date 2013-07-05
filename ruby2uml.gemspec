Gem::Specification.new do |s|
  s.name = "ruby2uml"
  s.description = "ruby2uml generates a UML Class diagram from Ruby source code."
  s.summary = "UML Class Diagram Generation"
  s.version = "0.1.2"
  s.date = Time.now.strftime('%Y-%m-%d')

  s.homepage = 'http://github.com/kcdragon/ruby2uml'
  s.authors = ['Michael Dalton']
  s.email = 'michaelcdalton@gmail.com'

  s.files = Dir['lib/**/*', 'config/*', 'README.md']
  s.executables = ['ruby2uml']

  s.add_runtime_dependency('ruby_parser', ['>= 3.1.3'])
end
