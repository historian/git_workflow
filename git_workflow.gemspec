# -*- encoding: utf-8 -*-
require File.expand_path("../lib/git_workflow/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "git_workflow"
  s.version     = GitWorkflow::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon Menke"]
  s.email       = ["simon.menke@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/git_workflow"
  s.summary     = "A workflow tool for Git"
  s.description = "Better workflow support for Git"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "git_workflow"

  s.add_runtime_dependency "opts", ">= 0.0.1"
  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
