module SidebarState
  extend ActiveSupport::Concern

  included do
    helper_method :sidebar_open?
  end

  private
    # The sidebar writes this cookie as it is toggled. Reading it here keeps the
    # first paint in step with the last choice instead of flashing open.
    def sidebar_open?
      cookies[:sidebar_state].nil? || cookies[:sidebar_state] == 'true'
    end
end
