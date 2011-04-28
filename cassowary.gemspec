# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cassowary}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sebastian Feuerstack"]
  s.date = %q{2011-04-28}
  s.description = %q{FIXME (describe your package)}
  s.email = %q{Sebastian@Feuerstack.org}
  s.executables = ["cassowary"]
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["History.txt", "bin/cassowary"]
  s.files = ["History.txt", "README.md", "Rakefile", "bin/cassowary", "ext/cassowary.i", "ext/cassowary_wrap.cxx", "ext/extconf.rb", "lib/cassowary.rb", "spec/cassowary_spec.rb", "spec/spec_helper.rb", "test/test_cassowary.rb", "version.txt"]
  s.homepage = %q{http://www.multi-access.de}
  s.rdoc_options = ["--main", "README.md"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = %q{cassowary}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{FIXME (describe your package)}
  s.test_files = ["test/test_cassowary.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bones>, [">= 3.6.5"])
    else
      s.add_dependency(%q<bones>, [">= 3.6.5"])
    end
  else
    s.add_dependency(%q<bones>, [">= 3.6.5"])
  end
end
