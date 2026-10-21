import { ComponentPropsWithoutRef } from 'react'
import { SidebarGroup, SidebarGroupContent, SidebarMenu, SidebarMenuButton, SidebarMenuItem } from '@/Components/ui/sidebar'
import { cn } from '@/lib/utils'
import { NavItem } from '@/types'

export default function NavFooter({
  items,
  className,
  ...props
}: ComponentPropsWithoutRef<typeof SidebarGroup> & { items: NavItem[] }) {
  return (
    <SidebarGroup {...props} className={cn('group-data-[collapsible=icon]:p-0', className)}>
      <SidebarGroupContent>
        <SidebarMenu>
          {items.map((item) => (
            <SidebarMenuItem key={item.title}>
              <SidebarMenuButton
                asChild
                className="text-neutral-600 hover:text-neutral-800 dark:text-neutral-300 dark:hover:text-neutral-100"
              >
                <a href={item.href} target="_blank" rel="noopener noreferrer">
                  {item.icon && <item.icon className="h-5 w-5" />}
                  <span>{item.title}</span>
                </a>
              </SidebarMenuButton>
            </SidebarMenuItem>
          ))}
        </SidebarMenu>
      </SidebarGroupContent>
    </SidebarGroup>
  )
}
