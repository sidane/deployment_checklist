# validates checklist from array of checklist_items 
# specified in RAILS_ROOT/config/deploy_checklist.yml
namespace :deploy do
  
  # deployment checklist is enabled by default
  # can be overriden in capistrano config file
  set :use_deployment_checklist, true
  
  task :checklist do
    if use_deployment_checklist
      checklist_items = load_checklist
      # if a checklist is specified
      unless checklist_items.empty?
        puts "=============================="
        puts "Deployment Checklist"
        puts "=============================="
        # display each question one at a time
        checklist_items.inject(1) do |counter, item|
          answer = Capistrano::CLI.ui.ask "#{counter}. " + item['question']
          answer.chomp! 
          item['valid_answer'] ||= 'y'
          unless (answer.downcase == item['valid_answer'].downcase)
            msg = "Deployment Aborted:\n"
            msg += "====================================================\n"
            msg += item['failure_message'] + "\n"
            msg += "===================================================="
            abort msg
          end
          counter += 1 
        end
      end
    end
  end
  
  task :load_checklist do
    filename = File.join(File.dirname(__FILE__), '../../../../', 'config/deploy_checklist.yml')
    return [] unless File::exists?(filename)
    file = File.new(filename)
    YAML.load(file)
  end
end

before :deploy, "deploy:checklist"