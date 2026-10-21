# A row in the sidebar: icon plus label, where the label hides when the rail is
# collapsed. The Inertia stacks get this from shadcn's sidebar; here the class
# strings are carried by hand, as with the other hotwire components.
class SidebarMenuButtonComponent < ViewComponent::Base
  BASE = 'flex h-8 w-full items-center gap-2 overflow-hidden rounded-md p-2 text-left text-sm ' \
         'outline-none transition-[width,height,padding] hover:bg-sidebar-accent ' \
         'hover:text-sidebar-accent-foreground focus-visible:ring-2 focus-visible:ring-sidebar-ring ' \
         'disabled:pointer-events-none disabled:opacity-50 [&>svg]:size-4 [&>svg]:shrink-0'

  ACTIVE = 'bg-sidebar-accent font-medium text-sidebar-accent-foreground'

  erb_template <<~ERB
    <a href="<%= @href %>" class="<%= @classes %>"<%= @external_attributes %>>
      <%= render(IconComponent.new(@icon)) if @icon %>
      <span x-show="sidebarOpen || sidebarOpenMobile" class="truncate"><%= content %></span>
    </a>
  ERB

  def initialize(href:, icon: nil, active: false, external: false, **attributes)
    @href = href
    @icon = icon
    @classes = [ BASE, (ACTIVE if active), attributes[:class] ].compact.join(' ')
    @external_attributes = (' target="_blank" rel="noopener noreferrer"'.html_safe if external)
  end
end
