class IssuesController < ApplicationController
  skip_before_filter :extract_user, :only => [:index, :show]
  before_filter :require_admin, :only => [:create, :update, :destroy]

  def show
    valid_http_methods :get
    required_parameters :id, :issue_tracker_id

    # NOTE: issue_tracker_id is here actually the name
    issue = nil
    begin
      issue = Issue.get_by_name_and_tracker( params[:id], params[:issue_tracker_id], params[:force_update] )
    rescue
      # not yet existing, try to create
      issue = Issue.find_or_create_by_name_and_tracker( params[:id], params[:issue_tracker_id] )
      issue = Issue.get_by_name_and_tracker( params[:id], params[:issue_tracker_id], 1 ) if params[:force_update]
    end

    render :text => issue.render_axml, :content_type => 'text/xml'
  end
end
