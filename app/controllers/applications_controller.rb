class ApplicationsController < ApplicationController
  active_scaffold do |config|
    config.list.columns << :status
    config.actions = [:list, :create, :update, :delete]
    config.action_links.add 'start', :label => 'Start', :type => :record
    config.action_links.add 'stop', :label => 'Stop', :type => :record
  end

  def start
    @application = Application.find(params[:id])
    @application.start
    render :text => 'Starting application'
  end

  def stop
    @application = Application.find(params[:id])
    @application.stop
    render :text => 'Stopping application'
  end
end
