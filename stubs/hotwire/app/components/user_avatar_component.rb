# The initials circle beside a user's name. The Inertia stacks build this from
# shadcn's avatar and a useInitials hook; here it is one component.
class UserAvatarComponent < ViewComponent::Base
  erb_template <<~ERB
    <span class="<%= @classes %>"><%= @initials %></span>
  ERB

  def initialize(name, classes: nil)
    @initials = initials(name)
    @classes = [
      'flex size-8 shrink-0 items-center justify-center rounded-full bg-neutral-200 text-xs',
      'font-medium text-black dark:bg-neutral-700 dark:text-white',
      classes
    ].compact.join(' ')
  end

  private
    def initials(name)
      parts = name.to_s.strip.split(/\s+/).reject(&:empty?)

      case parts.length
      when 0 then ''
      when 1 then parts.first[0].upcase
      else "#{parts.first[0]}#{parts.last[0]}".upcase
      end
    end
end
