import { useRef, useState, FormEventHandler } from 'react'
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
import InputError from '@/Components/InputError'
import { useForm } from '@inertiajs/react'
import { profile_destroy_path } from '@/routes'

export default function DeleteUserForm({ className = '' }: { className?: string }) {
  const [confirmingUserDeletion, setConfirmingUserDeletion] = useState(false)
  const passwordInput = useRef<HTMLInputElement>(null)

  const {
    data,
    setData,
    delete: destroy,
    processing,
    reset,
    errors,
    clearErrors,
  } = useForm({
    password: '',
  })

  const confirmUserDeletion = () => {
    setConfirmingUserDeletion(true)
  }

  const deleteUser: FormEventHandler = (e) => {
    e.preventDefault()

    destroy(profile_destroy_path(), {
      preserveScroll: true,
      onSuccess: () => closeModal(),
      onError: () => passwordInput.current?.focus(),
      onFinish: () => reset(),
    })
  }

  const closeModal = () => {
    setConfirmingUserDeletion(false)

    clearErrors()
    reset()
  }

  return (
    <section className={`space-y-6 ${className}`}>
      <header>
        <h2 className="text-lg font-medium text-gray-900 dark:text-gray-100">Delete Account</h2>

        <p className="mt-1 text-sm text-gray-600 dark:text-gray-400">
          Once your account is deleted, all of its resources and data will be permanently deleted. Before deleting your
          account, please download any data or information that you wish to retain.
        </p>
      </header>

      <Button variant="destructive" onClick={confirmUserDeletion}>
        Delete Account
      </Button>

      <Dialog open={confirmingUserDeletion} onOpenChange={(open) => !open && closeModal()}>
        <DialogContent>
          <form onSubmit={deleteUser}>
            <DialogHeader>
              <DialogTitle>Are you sure you want to delete your account?</DialogTitle>

              <DialogDescription>
                Once your account is deleted, all of its resources and data will be permanently deleted. Please enter
                your password to confirm you would like to permanently delete your account.
              </DialogDescription>
            </DialogHeader>

            <div className="mt-6">
              <Label htmlFor="password" className="sr-only">
                Password
              </Label>

              <Input
                id="password"
                type="password"
                name="password"
                ref={passwordInput}
                value={data.password}
                onChange={(e) => setData('password', e.target.value)}
                className="mt-1 block w-3/4"
                autoFocus
                placeholder="Password"
              />

              <InputError message={errors.password} className="mt-2" />
            </div>

            <DialogFooter>
              <Button type="button" variant="outline" onClick={closeModal}>
                Cancel
              </Button>

              <Button variant="destructive" disabled={processing}>
                Delete Account
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </section>
  )
}
