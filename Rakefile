\
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name     'cassowary'
  authors  'Sebastian Feuerstack'
  email    'Sebastian@Feuerstack.org'
  url      'http://www.multi-access.de'
  extensions ["ext/extconf.rb"]
}

