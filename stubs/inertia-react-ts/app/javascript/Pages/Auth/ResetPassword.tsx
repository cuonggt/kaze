import { FormEventHandler } from 'react'
import { Button } from '@/Components/ui/button'
import { Input } from '@/Components/ui/input'
import { Label } from '@/Components/ui/label'
import GuestLayout from '@/Layouts/GuestLayout'
import InputError from '@/Components/InputError'
import { Head, useForm } from '@inertiajs/react'
import { password_store_path } from '@/routes'

export default function ResetPassword({ token }: { token: string }) {
  const { data, setData, post, processing, errors, reset } = useForm({
    token: token,
    password: '',
    password_confirmation: '',
  })

  const submit: FormEventHandler = (e) => {
    e.preventDefault()

    post(password_store_path(), {
      onFinish: () => reset('password', 'password_confirmation'),
    })
  }

  return (
    <GuestLayout>
      <Head title="Reset password" />

      <form onSubmit={submit}>
        <div>
          <Label htmlFor="password">Password</Label>

          <Input
            id="password"
            type="password"
            name="password"
            value={data.password}
            className="mt-1 block w-full"
            autoComplete="new-password"
            autoFocus
            onChange={(e) => setData('password', e.target.value)}
          />

          <InputError message={errors.password} className="mt-2" />
        </div>

        <div className="mt-4">
          <Label htmlFor="password_confirmation">Confirm password</Label>

          <Input
            type="password"
            name="password_confirmation"
            value={data.password_confirmation}
            className="mt-1 block w-full"
            autoComplete="new-password"
            onChange={(e) => setData('password_confirmation', e.target.value)}
          />

          <InputError message={errors.password_confirmation} className="mt-2" />
        </div>

        <div className="flex items-center justify-end mt-4">
          <Button className="ms-4" disabled={processing}>
            Reset password
          </Button>
        </div>
      </form>
    </GuestLayout>
  )
}
