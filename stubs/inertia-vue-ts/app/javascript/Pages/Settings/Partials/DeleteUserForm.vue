<script setup lang="ts">
import InputError from '@/Components/InputError.vue'
import { Button } from '@/Components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/Components/ui/dialog'
import { Input } from '@/Components/ui/input'
import { Label } from '@/Components/ui/label'
import { useForm } from '@inertiajs/vue3'
import { nextTick, ref } from 'vue'
import { profile_destroy_path } from '@/routes'

const confirmingUserDeletion = ref(false)
const passwordInput = ref<HTMLInputElement | null>(null)

const form = useForm({
  password: '',
})

const confirmUserDeletion = () => {
  confirmingUserDeletion.value = true

  nextTick(() => passwordInput.value?.focus())
}

const deleteUser = () => {
  form.delete(profile_destroy_path(), {
    preserveScroll: true,
    onSuccess: () => closeModal(),
    onError: () => passwordInput.value?.focus(),
    onFinish: () => {
      form.reset()
    },
  })
}

const closeModal = () => {
  confirmingUserDeletion.value = false

  form.clearErrors()
  form.reset()
}
</script>

<template>
  <section class="space-y-6">
    <Button variant="destructive" @click="confirmUserDeletion">Delete account</Button>

    <Dialog v-model:open="confirmingUserDeletion">
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Are you sure you want to delete your account?</DialogTitle>

          <DialogDescription>
            Once your account is deleted, all of its resources and data will be permanently deleted. Please enter your
            password to confirm you would like to permanently delete your account.
          </DialogDescription>
        </DialogHeader>

        <div class="mt-6">
          <Label for="password" class="sr-only">Password</Label>

          <Input
            id="password"
            ref="passwordInput"
            v-model="form.password"
            type="password"
            class="mt-1 block w-3/4"
            placeholder="Password"
            @keyup.enter="deleteUser"
          />

          <InputError :message="form.errors.password" class="mt-2" />
        </div>

        <DialogFooter>
          <Button variant="outline" @click="closeModal"> Cancel </Button>

          <Button
            variant="destructive"
            :class="{ 'opacity-25': form.processing }"
            :disabled="form.processing"
            @click="deleteUser"
          >
            Delete account
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  </section>
</template>
