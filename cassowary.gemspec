# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cassowary}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Sebastian Feuerstack}]
  s.date = %q{2011-06-30}
  s.description = %q{Cassowary is an incremental constraint solving toolkit that efficiently 
solves systems of linear equalities and inequalities. Constraints may be 
either requirements or preferences. Client code specifies the constraints 
to be maintained, and the solver updates the constrained variables to have 
values that satisfy the constraints. Version 0.50 of the solving toolkit 
adds support for a one-way finite domain subsolver.

This project is concerned with offering a ruby interface for the
original implementation of cassowary in C.}
  s.email = [%q{Sebastian@Feuerstack.org}]
  s.extensions = [%q{ext/cassowary/extconf.rb}]
  s.extra_rdoc_files = [%q{History.txt}, %q{Manifest.txt}, %q{PostInstall.txt}]
  s.files = [%q{.autotest}, %q{History.txt}, %q{Manifest.txt}, %q{PostInstall.txt}, %q{README.rdoc}, %q{Rakefile}, %q{ext/cassowary/cassowary.so}, %q{ext/cassowary/extconf.rb}, %q{lib/cassowary.rb}, %q{script/console}, %q{script/destroy}, %q{script/generate}, %q{tasks/extconf.rake}, %q{tasks/extconf/cassowary.rake}, %q{test/test_cassowary.rb}, %q{test/test_helper.rb}, %q{.gemtest}]
  s.homepage = %q{http://github.com/sfeu/cassowary}
  s.rdoc_options = [%q{--main}, %q{README.rdoc}]
  s.require_paths = [%q{lib}, %q{ext/cassowary}]
  s.rubyforge_project = %q{cassowary}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Cassowary is an incremental constraint solving toolkit that efficiently  solves systems of linear equalities and inequalities}
  s.test_files = [%q{test/test_cassowary.rb}, %q{test/test_helper.rb}]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, ["~> 2.9"])
    else
      s.add_dependency(%q<hoe>, ["~> 2.9"])
    end
  else
    s.add_dependency(%q<hoe>, ["~> 2.9"])
  end
end
