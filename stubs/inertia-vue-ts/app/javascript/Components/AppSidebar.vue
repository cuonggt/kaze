<script setup lang="ts">
import { Link } from '@inertiajs/vue3'
import { BookOpen, FolderGit2, LayoutGrid } from '@lucide/vue'
import AppLogo from '@/Components/AppLogo.vue'
import NavFooter from '@/Components/NavFooter.vue'
import NavMain from '@/Components/NavMain.vue'
import NavUser from '@/Components/NavUser.vue'
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
</script>

<template>
  <Sidebar collapsible="icon" variant="inset">
    <SidebarHeader>
      <SidebarMenu>
        <SidebarMenuItem>
          <SidebarMenuButton size="lg" as-child>
            <Link :href="dashboard_path()">
              <AppLogo />
            </Link>
          </SidebarMenuButton>
        </SidebarMenuItem>
      </SidebarMenu>
    </SidebarHeader>

    <SidebarContent>
      <NavMain :items="mainNavItems" />
    </SidebarContent>

    <SidebarFooter>
      <NavFooter :items="footerNavItems" class="mt-auto" />
      <NavUser />
    </SidebarFooter>
  </Sidebar>
</template>
