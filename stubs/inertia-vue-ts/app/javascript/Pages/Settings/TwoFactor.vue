<script setup lang="ts">
import { Head, useForm } from '@inertiajs/vue3'
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue'
import SettingsLayout from '@/Layouts/SettingsLayout.vue'
import Heading from '@/Components/Heading.vue'
import InputError from '@/Components/InputError.vue'
import { Button } from '@/Components/ui/button'
import { Input } from '@/Components/ui/input'
import { Label } from '@/Components/ui/label'
import {
  two_factor_destroy_path,
  two_factor_edit_path,
  two_factor_recovery_codes_path,
  two_factor_store_path,
  two_factor_update_path,
} from '@/routes'
import { BreadcrumbItem } from '@/types'

defineProps<{
  enabled: boolean
  pending: boolean
  qrCode: string | null
  secret: string | null
  recoveryCodes: string[]
}>()

const breadcrumbs: BreadcrumbItem[] = [
  {
    title: 'Two factor settings',
    href: two_factor_edit_path(),
  },
]

const enableForm = useForm({})
const confirmForm = useForm({ code: '' })
const regenerateForm = useForm({})
const disableForm = useForm({ password: '' })
</script>

<template>
  <Head title="Two factor settings" />

  <AuthenticatedLayout :breadcrumbs="breadcrumbs">
    <SettingsLayout>
      <div class="space-y-6">
        <Heading
          variant="small"
          title="Two factor authentication"
          description="Add a second step to signing in, using an authenticator app"
        />

        <template v-if="enabled">
          <p class="text-sm text-muted-foreground">
            Two factor authentication is on. You will be asked for a code each time you sign in.
          </p>

          <div class="space-y-3 rounded-xl border border-sidebar-border/70 p-4 dark:border-sidebar-border">
            <div class="text-sm font-medium">Recovery codes</div>

            <p class="text-sm text-muted-foreground">
              Keep these somewhere safe. Each one can be used once to sign in if you cannot reach your authenticator
              app.
            </p>

            <ul class="grid grid-cols-2 gap-1 font-mono text-xs">
              <li v-for="recoveryCode in recoveryCodes" :key="recoveryCode">{{ recoveryCode }}</li>
            </ul>

            <form @submit.prevent="regenerateForm.post(two_factor_recovery_codes_path())">
              <Button variant="outline" :disabled="regenerateForm.processing">Generate new codes</Button>
            </form>
          </div>

          <form class="space-y-6" @submit.prevent="disableForm.delete(two_factor_destroy_path())">
            <div>
              <Label for="password">Current password</Label>

              <Input
                id="password"
                v-model="disableForm.password"
                type="password"
                name="password"
                class="mt-1 block w-full max-w-xs"
                autocomplete="current-password"
              />

              <InputError :message="disableForm.errors.password" class="mt-2" />
            </div>

            <Button variant="destructive" :disabled="disableForm.processing">
              Turn off two factor authentication
            </Button>
          </form>
        </template>

        <template v-else-if="pending">
          <p class="text-sm text-muted-foreground">
            Scan this with your authenticator app, then enter the code it shows to finish turning it on.
          </p>

          <!-- eslint-disable-next-line vue/no-v-html -->
          <div
            v-if="qrCode"
            class="w-44 rounded-lg border border-sidebar-border/70 bg-white p-2 dark:border-sidebar-border"
            v-html="qrCode"
          />

          <p class="text-sm text-muted-foreground">
            Cannot scan it? Enter this key instead:
            <code class="rounded bg-muted px-1.5 py-0.5 font-mono text-xs text-foreground">{{ secret }}</code>
          </p>

          <form class="space-y-6" @submit.prevent="confirmForm.patch(two_factor_update_path())">
            <div>
              <Label for="code">Code</Label>

              <Input
                id="code"
                v-model="confirmForm.code"
                name="code"
                class="mt-1 block w-full max-w-xs"
                inputmode="numeric"
                autocomplete="one-time-code"
                autofocus
              />

              <InputError :message="confirmForm.errors.code" class="mt-2" />
            </div>

            <Button :disabled="confirmForm.processing">Confirm</Button>
          </form>
        </template>

        <template v-else>
          <p class="text-sm text-muted-foreground">
            Two factor authentication is off. Turn it on and you will be asked for a code from your authenticator app
            each time you sign in.
          </p>

          <form @submit.prevent="enableForm.post(two_factor_store_path())">
            <Button :disabled="enableForm.processing">Turn on two factor authentication</Button>
          </form>
        </template>
      </div>
    </SettingsLayout>
  </AuthenticatedLayout>
</template>
