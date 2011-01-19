def sh(*args)
  puts args
  system *args
end

sh "cp config/database.yml.example config/database.yml"

print "Are you using postgresql or mysql? (Default is postgresql) "
if $stdin.gets.chomp[/^m/]
  gemfile = File.read('Gemfile').sub(/(gem\s*"pg")/, '#\1').
    sub(/(?:#\s*(gem "mysql"))/, '\1')
  File.open('Gemfile', 'w') {|f| f.write gemfile }
  database_yml = File.read("config/database.yml").gsub('postgresql', 'mysql')
  File.open('config/database.yml', 'w') {|f| f.write database_yml }
end

sh "gem install bundler"
sh "bundle install --path vendor/bundler_gems"
sh "rake db:create:all"
sh "rake db:migrate"
