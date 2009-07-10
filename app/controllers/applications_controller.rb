class ApplicationsController < ApplicationController
  active_scaffold do |config|
    config.list.columns << :status
    config.actions = [:list, :create, :update, :delete]
    config.action_links.add 'start', :label => 'Start', :type => :record, :position => :after
    config.action_links.add 'stop', :label => 'Stop', :type => :record, :position => :after
  end

  def start
    @application = Application.find(params[:id])
    status, output = @application.start
    render :text => output #'Starting application'
  end

  def stop
    @application = Application.find(params[:id])
    status, output = @application.stop
    render :text => 'Stopping application'
  end
end
