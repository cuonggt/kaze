import { Link } from '@inertiajs/react'
import { BookOpen, FolderGit2, LayoutGrid } from 'lucide-react'
import AppLogo from '@/Components/AppLogo'
import NavFooter from '@/Components/NavFooter'
import NavMain from '@/Components/NavMain'
import NavUser from '@/Components/NavUser'
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from '@/Components/ui/sidebar'
import { dashboard_path } from '@/routes'
import { NavItem } from '@/types'

const mainNavItems: NavItem[] = [
  {
    title: 'Dashboard',
    href: dashboard_path(),
    icon: LayoutGrid,
  },
]

const footerNavItems: NavItem[] = [
  {
    title: 'Repository',
    href: 'https://github.com/cuonggt/kaze',
    icon: FolderGit2,
  },
  {
    title: 'Documentation',
    href: 'https://github.com/cuonggt/kaze#readme',
    icon: BookOpen,
  },
]

export default function AppSidebar() {
  return (
    <Sidebar collapsible="icon" variant="inset">
      <SidebarHeader>
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton size="lg" asChild>
              <Link href={dashboard_path()} prefetch>
                <AppLogo />
              </Link>
            </SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>

      <SidebarContent>
        <NavMain items={mainNavItems} />
      </SidebarContent>

      <SidebarFooter>
        <NavFooter items={footerNavItems} className="mt-auto" />
        <NavUser />
      </SidebarFooter>
    </Sidebar>
  )
}
