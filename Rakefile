#require 'rubygems'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.platform  =   Gem::Platform::RUBY
  s.name      =   "rudoku"
  s.version   =   "0.1"
  s.author    =   "Reto Schüttel"
  s.email     =   "reto <hugh> at <yoh!> schuettel doto ch"
  s.summary   =   "Sudoku Engine."
  s.requirements << 'none'
  s.homepage  = ""
  s.files     =   FileList['lib/*.rb'].to_a
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
end
