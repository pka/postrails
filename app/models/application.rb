class Application < ActiveRecord::Base
  include FileUtils

  validates_format_of :name, :with => /[a-z][a-z0-9_]*/i, :on => :create
  validates_uniqueness_of :name

  before_create :create_railsapp
  before_destroy :destroy_railsapp

  def railsapp_path
    "#{DEPLOY_ROOT}/#{name}"
  end

  def url(server)
    "http://#{server}:#{port}/"
  end

  def create_railsapp
    destroy_railsapp
    system("rails #{railsapp_path}")
  end

  def destroy_railsapp
    rm_rf railsapp_path
  end

  def start
    system("cd #{railsapp_path} && ./script/server start --daemon -p #{port}")
  end

  def stop
    system("cat #{railsapp_path}/tmp/pids/server.pid | xargs kill")
  end
end
