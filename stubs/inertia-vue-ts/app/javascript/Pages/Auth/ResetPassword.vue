<script setup lang="ts">
import GuestLayout from '@/Layouts/GuestLayout.vue'
import { Button } from '@/Components/ui/button'
import { Input } from '@/Components/ui/input'
import { Label } from '@/Components/ui/label'
import InputError from '@/Components/InputError.vue'
import { Head, useForm } from '@inertiajs/vue3'
import { password_store_path } from '@/routes'

const props = defineProps<{
  token: string
}>()

const form = useForm({
  token: props.token,
  password: '',
  password_confirmation: '',
})

const submit = () => {
  form.post(password_store_path(), {
    onFinish: () => {
      form.reset('password', 'password_confirmation')
    },
  })
}
</script>

<template>
  <GuestLayout>
    <Head title="Reset password" />

    <form @submit.prevent="submit">
      <div>
        <Label for="password">Password</Label>

        <Input
          id="password"
          type="password"
          class="mt-1 block w-full"
          v-model="form.password"
          required
          autofocus
          autocomplete="new-password"
        />

        <InputError class="mt-2" :message="form.errors.password" />
      </div>

      <div class="mt-4">
        <Label for="password_confirmation">Confirm password</Label>

        <Input
          id="password_confirmation"
          type="password"
          class="mt-1 block w-full"
          v-model="form.password_confirmation"
          required
          autocomplete="new-password"
        />

        <InputError class="mt-2" :message="form.errors.password_confirmation" />
      </div>

      <div class="flex items-center justify-end mt-4">
        <Button :class="{ 'opacity-25': form.processing }" :disabled="form.processing"> Reset password </Button>
      </div>
    </form>
  </GuestLayout>
</template>
