import GuestLayout from '@/Layouts/GuestLayout'
import { Button } from '@/Components/ui/button'
import { Input } from '@/Components/ui/input'
import InputError from '@/Components/InputError'
import { Head, useForm } from '@inertiajs/react'
import { FormEventHandler } from 'react'
import { password_email_path } from '@/routes'

export default function ForgotPassword({ status }: { status?: string }) {
  const { data, setData, post, processing, errors } = useForm({
    email: '',
  })

  const submit: FormEventHandler = (e) => {
    e.preventDefault()

    post(password_email_path())
  }

  return (
    <GuestLayout>
      <Head title="Forgot password" />

      <div className="mb-4 text-sm text-gray-600 dark:text-gray-400">
        Forgot your password? No problem. Just let us know your email address and we will email you a password reset
        link that will allow you to choose a new one.
      </div>

      {status && <div className="mb-4 font-medium text-sm text-green-600 dark:text-green-400">{status}</div>}

      <form onSubmit={submit}>
        <Input
          id="email"
          type="email"
          name="email"
          value={data.email}
          className="mt-1 block w-full"
          autoFocus
          onChange={(e) => setData('email', e.target.value)}
        />

        <InputError message={errors.email} className="mt-2" />

        <div className="flex items-center justify-end mt-4">
          <Button className="ms-4" disabled={processing}>
            Email password reset link
          </Button>
        </div>
      </form>
    </GuestLayout>
  )
}
