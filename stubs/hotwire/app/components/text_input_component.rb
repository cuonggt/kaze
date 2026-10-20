class TextInputComponent < ViewComponent::Base
  erb_template <<~ERB
    <input <%= @disabled ? "disabled" : "" %> <%= sanitize @attributes.join(" ") %>>
  ERB

  def initialize(attributes = {})
    @disabled = attributes[:disabled] || false
    attributes[:class] = "border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-300 focus:border-indigo-500 dark:focus:border-indigo-600 focus:ring-indigo-500 dark:focus:ring-indigo-600 rounded-md shadow-xs#{" #{attributes[:class]}" if attributes[:class]}"
    @attributes = attributes.without(:disabled).map { |key, attribute| "#{key}=\"#{attribute}\"" }
  end
end
