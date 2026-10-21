# Inlines the lucide icons the layouts use. The Inertia stacks get these from
# the lucide package; there is no npm here, so the paths are carried by hand.
# Each entry is the body of lucide's 24x24 outline svg.
class IconComponent < ViewComponent::Base
  PATHS = {
    "book-open" => '<path d="M12 5v16" /><path d="M20.001 19A2 2 0 0022 17V5a2 2 0 00-1.999-2L16 3.002A5 5 0 0012 5a5 5 0 00-4-2H4a2 2 0 00-2 2v12a2 2 0 001.999 2H8a5 5 0 014 2 5 5 0 014-2z" />',
    "chevron-right" => '<path d="m9 18 6-6-6-6" />',
    "chevrons-up-down" => '<path d="m7 15 5 5 5-5" /><path d="m7 9 5-5 5 5" />',
    "folder-git-2" => '<path d="M18 19a5 5 0 0 1-5-5v8" /><path d="M9 20H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H20a2 2 0 0 1 2 2v5" /><circle cx="13" cy="12" r="2" /><circle cx="20" cy="19" r="2" />',
    "layout-grid" => '<rect width="7" height="7" x="3" y="3" rx="1" /><rect width="7" height="7" x="14" y="3" rx="1" /><rect width="7" height="7" x="14" y="14" rx="1" /><rect width="7" height="7" x="3" y="14" rx="1" />',
    "panel-left-close" => '<rect width="18" height="18" x="3" y="3" rx="2" /><path d="M9 3v18" /><path d="m16 15-3-3 3-3" />',
    "panel-left-open" => '<rect width="18" height="18" x="3" y="3" rx="2" /><path d="M9 3v18" /><path d="m14 9 3 3-3 3" />'
  }.freeze

  erb_template <<~ERB
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
      stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
      class="<%= @classes %>" aria-hidden="true"><%= @path %></svg>
  ERB

  def initialize(name, classes: "size-4")
    @path = PATHS.fetch(name) { raise ArgumentError, "unknown icon: #{name}" }.html_safe
    @classes = classes
  end
end
