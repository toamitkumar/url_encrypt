# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{url_encrypt}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Amit Kumar"]
  s.date = %q{2010-05-02}
  s.description = %q{Encrypt your URLs}
  s.email = %q{toamitkumar@gmail.com}
  s.extra_rdoc_files = ["README", "lib/url_encrypt.rb", "tasks/url_encrypt_tasks.rake"]
  s.files = ["MIT-LICENSE", "README", "Rakefile", "init.rb", "install.rb", "lib/url_encrypt.rb", "tasks/url_encrypt_tasks.rake", "test/test_helper.rb", "test/url_encrypt_test.rb", "uninstall.rb", "Manifest", "url_encrypt.gemspec"]
  s.homepage = %q{http://github.com/toamitkumar/url_encrypt}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Url_encrypt", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{url_encrypt}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Encrypt your URLs}
  s.test_files = ["test/url_encrypt_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
