# The trail in the sidebar header. Takes [{ title:, href: }], where the last
# entry is the current page and is not a link.
class BreadcrumbsComponent < ViewComponent::Base
  erb_template <<~ERB
    <nav aria-label="breadcrumb">
      <ol class="flex flex-wrap items-center gap-1.5 text-sm break-words text-muted-foreground sm:gap-2.5">
        <% @items.each_with_index do |item, index| %>
          <li class="inline-flex items-center gap-1.5">
            <% if index == @items.length - 1 %>
              <span class="font-normal text-foreground" aria-current="page"><%= item[:title] %></span>
            <% else %>
              <a href="<%= item[:href] %>" class="transition-colors hover:text-foreground"><%= item[:title] %></a>
            <% end %>
          </li>
          <% unless index == @items.length - 1 %>
            <li role="presentation" aria-hidden="true">
              <%= render(IconComponent.new('chevron-right', classes: 'size-3.5')) %>
            </li>
          <% end %>
        <% end %>
      </ol>
    </nav>
  ERB

  def initialize(items)
    @items = items
  end

  def render?
    @items.present?
  end
end
