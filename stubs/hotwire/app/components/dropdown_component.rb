class DropdownComponent < ViewComponent::Base
  renders_one :trigger

  # `side` is which way the menu opens off the trigger. The sidebar's user row
  # sits at the foot of the viewport, so it opens upwards; everything else
  # opens downwards.
  def initialize(align: 'right', side: 'bottom', width: '48', content_classes: 'p-1 bg-popover text-popover-foreground')
    if align == 'left'
      @alignment_classes = 'ltr:origin-top-left rtl:origin-top-right start-0'
    elsif align == 'top'
      @alignment_classes = 'origin-top'
    else
      @alignment_classes = 'ltr:origin-top-right rtl:origin-top-left end-0'
    end
    @side_classes = side == 'top' ? 'bottom-full mb-2' : 'mt-2'
    @width = width == '48' ? 'w-48' : width
    @content_classes = content_classes
  end
end
