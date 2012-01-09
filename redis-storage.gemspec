Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.8.10'

  s.name              = 'extraloop-redis-storage'
  s.version           = '0.0.1'
  s.date              = '2012-01-07'
  s.rubyforge_project = 'extraloop-redis-storage'

  s.summary     = "Redis storage for Extraloop."
  s.description = "Redis+Ohm based storage for data sets extracted using the ExtraLoop toolkit."

  s.authors  = ["Andrea Fiore"]
  s.email    = 'andrea.giulio.fiore@googlemail.com'
  s.homepage = 'http://github.com/afiore/extraloop-redis-storage'

  s.require_paths = %w[lib]
  s.executables = []

  s.rdoc_options = ["--charset=UTF-8"]

  s.add_runtime_dependency('extraloop', "~> 0.0.3")
  s.add_runtime_dependency('ohm', "~> 0.1.3")
  s.add_runtime_dependency('ohm-contrib', "~> 0.1.2")

  s.add_development_dependency('rspec', "~> 2.7.1")
  s.add_development_dependency('rr', "~> 1.0.4")
  s.add_development_dependency('pry', "~> 0.9.7.4")
  
  # = MANIFEST =
  s.files = %w[
    History.txt
    README.rdoc
  ] + (`git ls-files examples lib spec`).split("\n")
  # = MANIFEST =
end