class DropdownComponent < ViewComponent::Base
  renders_one :trigger

  def initialize(align: 'right', width: '48', content_classes: 'p-1 bg-popover text-popover-foreground')
    if align == 'left'
      @alignment_classes = 'ltr:origin-top-left rtl:origin-top-right start-0'
    elsif align == 'top'
      @alignment_classes = 'origin-top'
    else
      @alignment_classes = 'ltr:origin-top-right rtl:origin-top-left end-0'
    end
    @width = width == '48' ? 'w-48' : width
    @content_classes = content_classes
  end
end
