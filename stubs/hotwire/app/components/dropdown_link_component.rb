class DropdownLinkComponent < ViewComponent::Base
  erb_template <<~ERB
    <a <%= sanitize @attributes.join(" ") %>>
      <%= content %>
    </a>
  ERB

  def initialize(attributes = {})
    attributes[:class] = "block w-full px-4 py-2 text-start text-sm leading-5 text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 focus:outline-hidden focus:bg-gray-100 dark:focus:bg-gray-800 transition duration-150 ease-in-out#{" #{attributes[:class]}" if attributes[:class]}"
    @attributes = attributes.map { |key, attribute| "#{key}=\"#{attribute}\"" }
  end
end
