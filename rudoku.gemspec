# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rudoku}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Reto Sch\303\274ttel"]
  s.date = %q{2009-04-23}
  s.description = %q{Rudoku is a simple Sudoku solver.}
  s.email = %q{reto <hugh> at <yoh!> schuettel doto ch}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "lib/rudoku.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/retoo/rudoku}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.requirements = ["none"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Sudoku Engine.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
