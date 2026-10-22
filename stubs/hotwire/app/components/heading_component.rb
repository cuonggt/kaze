# A section heading with an optional description. `small` is the variant the
# settings pages use above each form.
class HeadingComponent < ViewComponent::Base
  erb_template <<~ERB
    <header class="<%= @header_classes %>">
      <h2 class="<%= @title_classes %>"><%= @title %></h2>
      <% if @description %>
        <p class="text-sm text-muted-foreground"><%= @description %></p>
      <% end %>
    </header>
  ERB

  def initialize(title:, description: nil, variant: 'default')
    @title = title
    @description = description
    @header_classes = variant == 'small' ? '' : 'mb-8 space-y-0.5'
    @title_classes = variant == 'small' ? 'mb-0.5 text-base font-medium' : 'text-xl font-semibold tracking-tight'
  end
end
