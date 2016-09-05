Gem::Specification.new do |spec|
  spec.name          = 'lita-quest'
  spec.version       = '0.1.0'
  spec.authors       = ['Jester']
  spec.email         = ['jester.dash@gmail.com']
  spec.description   = 'Quest Bot'
  spec.summary       = 'Quest Bot'
  spec.homepage      = ''
  spec.license       = 'MIT License'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 4.7'
  spec.add_runtime_dependency 'sequel', '~> 4.37.0'
  spec.add_runtime_dependency 'pg', '~> 0.18.4'
  spec.add_runtime_dependency 'dotenv', '~> 2.1.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'dotenv'
end
