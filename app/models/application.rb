class Application < ActiveRecord::Base
  include FileUtils

  validates_format_of :name, :with => /[a-z][a-z0-9_]*/i, :on => :create
  validates_uniqueness_of :name

  before_create :create_railsapp
  before_destroy :destroy_railsapp

  attr_accessor :tables

  def railsapp_path
    "#{DEPLOY_ROOT}/#{name}"
  end

  def url(server)
    "http://#{server}:#{port}/"
  end

  def create_railsapp
    destroy_railsapp
    table_list = (tables || []).join(',')
    Shell.run("TABLES=#{table_list} PARENT_ROOT=#{RAILS_ROOT} rails --template=#{APP_TEMPLATE} #{railsapp_path}")
  end

  def destroy_railsapp
    stop if running?
    rm_rf railsapp_path
  end

  def start
    Shell.run("cd #{railsapp_path} && ./script/server start --daemon -p #{port}")
  end

  def stop
    Shell.run("cat #{railsapp_path}/tmp/pids/server.pid | xargs kill")
  end

  def status
    status, pslines = Shell.run("ps -p `cat #{railsapp_path}/tmp/pids/server.pid` | wc -l")
    pslines == "2\n" ? 'running' : 'stopped'
  end

  def running?
    status == 'running'
  end

end
