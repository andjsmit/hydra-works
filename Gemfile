source 'https://rubygems.org'

# Specify your gem's dependencies in hydra-works.gemspec
gemspec

gem 'active-fedora', github:'projecthydra/active_fedora', branch: 'master'
gem 'hydra-derivatives', github:'projecthydra/hydra-derivatives', branch: 'master'
gem 'hydra-pcdm', github:'projecthydra/hydra-pcdm', branch: 'member_of'
gem 'slop', '~> 3.6' # For byebug

group :development, :test do
  gem 'rubocop', '~> 0.37.2', require: false
  gem 'rubocop-rspec', require: false
  gem 'pry' unless ENV['CI']
  gem 'pry-byebug' unless ENV['CI']
end
