run "rm README"

# Install plugins
#plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git'

parent_root = ENV['PARENT_ROOT'] || "#{RAILS_ROOT}/../.."

run "cp #{parent_root}/config/database.yml config/database.yml"
run "cp -r #{parent_root}/vendor/plugins/crud_scaffold_generator vendor/plugins"

tables = ENV['TABLES'].split(',')
tables.each do |table|
  #generate(:model, "--skip-migration --skip-fixture", table.singularize)
  #generate(:scaffold, "--skip-migration", table.singularize)
  generate(:crud_scaffold, table.classify)
end

run "rm -rf vendor/plugins/crud_scaffold_generator"

unless tables.empty?
  run "rm public/index.html"
  route "map.root :controller => '#{tables.first}'"
end
