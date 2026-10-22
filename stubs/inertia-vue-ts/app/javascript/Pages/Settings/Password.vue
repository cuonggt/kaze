<script setup lang="ts">
import { Head } from '@inertiajs/vue3'
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import SettingsLayout from '@/Layouts/SettingsLayout.vue'
import Heading from '@/Components/Heading.vue'
import UpdatePasswordForm from './Partials/UpdatePasswordForm.vue'
import { password_edit_path } from '@/routes'
import { BreadcrumbItem } from '@/types'

const breadcrumbs: BreadcrumbItem[] = [
  {
    title: 'Password settings',
    href: password_edit_path(),
  },
]
</script>

<template>
  <Head title="Password settings" />

  <AuthenticatedLayout :breadcrumbs="breadcrumbs">
    <SettingsLayout>
      <div class="space-y-6">
        <Heading
          variant="small"
          title="Update password"
          description="Ensure your account is using a long, random password to stay secure"
        />
        <UpdatePasswordForm />
      </div>
    </SettingsLayout>
  </AuthenticatedLayout>
</template>
