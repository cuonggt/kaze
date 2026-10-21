module HandleInertiaRequests
  extend ActiveSupport::Concern

  included do
    inertia_share do
      {
        auth: { user: Current.auth.get_user },
        sidebar_open: cookies[:sidebar_state].nil? || cookies[:sidebar_state] == "true"
      }
    end
  end
end
