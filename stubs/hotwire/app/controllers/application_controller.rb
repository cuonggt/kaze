class ApplicationController < ActionController::Base
  include SetCurrentAuth
  include Authenticate
  include SidebarState
end
