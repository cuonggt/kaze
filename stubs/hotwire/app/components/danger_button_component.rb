class DangerButtonComponent < ViewComponent::Base
  erb_template <<~ERB
    <button <%= sanitize @attributes.join(" ") %>>
      <%= content %>
    </button>
  ERB

  def initialize(attributes = {})
    attributes[:type] = attributes[:type] || 'submit'
    attributes[:class] = "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-[color,box-shadow] disabled:pointer-events-none disabled:opacity-50 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] h-9 px-4 py-2 bg-destructive text-white shadow-xs hover:bg-destructive/90 focus-visible:ring-destructive/20 dark:focus-visible:ring-destructive/40#{" #{attributes[:class]}" if attributes[:class]}"
    @attributes = attributes.map { |key, attribute| "#{key}=\"#{attribute}\"" }
  end
end
