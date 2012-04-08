Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.8.10'

  s.name              = 'extraloop-redis-storage'
  s.version           = '0.0.12'
  s.date              = '2012-04-08'
  s.rubyforge_project = 'extraloop-redis-storage'

  s.summary     = "Redis storage for Extraloop."
  s.description = "Redis-based Persistence layer for the ExtraLoop data extraction toolkit. Includes a convinent command line tool allowing to list, filter, delete, and export harvested datasets"

  s.authors  = ["Andrea Fiore"]
  s.email    = 'andrea.giulio.fiore@googlemail.com'
  s.homepage = 'http://github.com/afiore/extraloop-redis-storage'

  s.require_paths = %w[lib]
  s.executables = ['extraloop']

  s.rdoc_options = ["--charset=UTF-8"]

  s.add_runtime_dependency('extraloop', "~> 0.0.3")
  s.add_runtime_dependency('ohm', "~> 0.1.3")
  s.add_runtime_dependency('ohm-contrib', "~> 0.1.2")
  s.add_runtime_dependency('thor', "0.14.6")

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', "~> 2.7.0")
  s.add_development_dependency('guard-rspec', "~> 0.7.0")
  s.add_development_dependency('rr', "~> 1.0.4")
  s.add_development_dependency('pry', "~> 0.9.7.4")
  s.add_development_dependency('fusion_tables', "~> 0.3.1")
  s.add_development_dependency('geocoder', '~> 1.1.1')
  
  # = MANIFEST =
  s.files = %w[
    History.txt
    README.rdoc
  ] + (`git ls-files examples lib spec`).split("\n")
  # = MANIFEST =
end
