class InputLabelComponent < ViewComponent::Base
  erb_template <<~ERB
    <label <%= sanitize @attributes.join(" ") %>>
      <%= @value ? @value : content %>
    </label>
  ERB

  def initialize(attributes = {})
    @value = attributes[:value] || nil
    attributes[:class] = "flex items-center gap-2 text-sm leading-none font-medium select-none peer-disabled:cursor-not-allowed peer-disabled:opacity-50#{" #{attributes[:class]}" if attributes[:class]}"
    @attributes = attributes.without(:value).map { |key, attribute| "#{key}=\"#{attribute}\"" }
  end
end
