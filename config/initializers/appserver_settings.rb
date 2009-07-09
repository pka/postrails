# Application server settings

DEPLOY_ROOT = "#{RAILS_ROOT}/applications"
FileUtils.mkdir_p DEPLOY_ROOT
APP_TEMPLATE = "#{RAILS_ROOT}/lib/app_template.rb"
