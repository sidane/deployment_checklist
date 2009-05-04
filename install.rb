require 'fileutils'

# move YAML config file template to RAILS_ROOT/config/
cwd = File.dirname(__FILE__)
FileUtils.cp(File.join(cwd, 'recipes/templates/deploy_checklist.yml'), File.join(cwd, '../../../config/'))

puts IO.read(File.join(File.dirname(__FILE__), 'README'))