<script setup lang="ts">
import { Link, router } from '@inertiajs/vue3'
import { LogOut, Settings } from '@lucide/vue'
import {
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
} from '@/Components/ui/dropdown-menu'
import UserInfo from '@/Components/UserInfo.vue'
import { logout_path, profile_edit_path } from '@/routes'
import { User } from '@/types'

defineProps<{ user: User }>()

const handleLogout = () => {
  router.flushAll()
}
</script>

<template>
  <DropdownMenuLabel class="p-0 font-normal">
    <div class="flex items-center gap-2 px-1 py-1.5 text-left text-sm">
      <UserInfo :user="user" show-email />
    </div>
  </DropdownMenuLabel>

  <DropdownMenuSeparator />

  <DropdownMenuGroup>
    <DropdownMenuItem as-child>
      <Link class="block w-full cursor-pointer" :href="profile_edit_path()">
        <Settings class="mr-2 h-4 w-4" />
        Settings
      </Link>
    </DropdownMenuItem>
  </DropdownMenuGroup>

  <DropdownMenuSeparator />

  <DropdownMenuItem as-child>
    <Link class="block w-full cursor-pointer" :href="logout_path()" method="post" as="button" @click="handleLogout">
      <LogOut class="mr-2 h-4 w-4" />
      Log out
    </Link>
  </DropdownMenuItem>
</template>
