<script setup lang="ts">
import { Link, usePage } from '@inertiajs/vue3'
import Heading from '@/Components/Heading.vue'
import { Button } from '@/Components/ui/button'
import { Separator } from '@/Components/ui/separator'
import { cn } from '@/lib/utils'
import { appearance_edit_path, password_edit_path, profile_edit_path } from '@/routes'
import { NavItem } from '@/types'

const sidebarNavItems: NavItem[] = [
  {
    title: 'Profile',
    href: profile_edit_path(),
  },
  {
    title: 'Password',
    href: password_edit_path(),
  },
  {
    title: 'Appearance',
    href: appearance_edit_path(),
  },
]

const page = usePage()
</script>

<template>
  <div class="px-4 py-6">
    <Heading title="Settings" description="Manage your profile and account settings" />

    <div class="flex flex-col lg:flex-row lg:space-x-12">
      <aside class="w-full max-w-xl lg:w-48">
        <nav class="flex flex-col space-y-1 space-x-0" aria-label="Settings">
          <Button
            v-for="item in sidebarNavItems"
            :key="item.href"
            size="sm"
            variant="ghost"
            as-child
            :class="cn('w-full justify-start', { 'bg-muted': page.url.startsWith(item.href) })"
          >
            <Link :href="item.href">{{ item.title }}</Link>
          </Button>
        </nav>
      </aside>

      <Separator class="my-6 lg:hidden" />

      <div class="flex-1 md:max-w-2xl">
        <section class="max-w-xl space-y-12">
          <slot />
        </section>
      </div>
    </div>
  </div>
</template>
