# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mongomatic}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Myles"]
  s.date = %q{2010-08-15}
  s.description = %q{Mongomatic is a simple Ruby object mapper for Mongo}
  s.email = %q{ben.myles@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "lib/mongomatic.rb",
     "lib/mongomatic/base.rb",
     "lib/mongomatic/cursor.rb",
     "lib/mongomatic/errors.rb",
     "lib/mongomatic/expectations.rb",
     "lib/mongomatic/expectations/expected.rb",
     "lib/mongomatic/expectations/is_number.rb",
     "lib/mongomatic/expectations/match.rb",
     "lib/mongomatic/expectations/of_length.rb",
     "lib/mongomatic/expectations/present.rb",
     "lib/mongomatic/modifiers.rb"
  ]
  s.homepage = %q{http://mongomatic.com/}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Mongomatic is a simple Ruby object mapper for Mongo}
  s.test_files = [
    "test/helper.rb",
     "test/test_mongomatic.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 2.11.1"])
      s.add_runtime_dependency(%q<bson>, [">= 1.0.4"])
      s.add_runtime_dependency(%q<bson_ext>, [">= 1.0.4"])
      s.add_runtime_dependency(%q<mongo>, [">= 1.0.7"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.5"])
    else
      s.add_dependency(%q<shoulda>, [">= 2.11.1"])
      s.add_dependency(%q<bson>, [">= 1.0.4"])
      s.add_dependency(%q<bson_ext>, [">= 1.0.4"])
      s.add_dependency(%q<mongo>, [">= 1.0.7"])
      s.add_dependency(%q<activesupport>, [">= 2.3.5"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 2.11.1"])
    s.add_dependency(%q<bson>, [">= 1.0.4"])
    s.add_dependency(%q<bson_ext>, [">= 1.0.4"])
    s.add_dependency(%q<mongo>, [">= 1.0.7"])
    s.add_dependency(%q<activesupport>, [">= 2.3.5"])
  end
end

