class DropdownLinkComponent < ViewComponent::Base
  erb_template <<~ERB
    <a <%= sanitize @attributes.join(" ") %>>
      <%= content %>
    </a>
  ERB

  def initialize(attributes = {})
    attributes[:class] = "relative flex w-full cursor-default items-center gap-2 rounded-sm px-2 py-1.5 text-start text-sm outline-hidden select-none transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground#{" #{attributes[:class]}" if attributes[:class]}"
    @attributes = attributes.map { |key, attribute| "#{key}=\"#{attribute}\"" }
  end
end
