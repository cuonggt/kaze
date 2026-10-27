import GuestLayout from '@/Layouts/GuestLayout'
import { Button } from '@/Components/ui/button'
import { Input } from '@/Components/ui/input'
import { Label } from '@/Components/ui/label'
import InputError from '@/Components/InputError'
import { Head, useForm } from '@inertiajs/react'
import { FormEventHandler } from 'react'
import { two_factor_challenge_store_path } from '@/routes'

export default function TwoFactorChallenge() {
  const { data, setData, post, processing, errors } = useForm({
    code: '',
    recovery_code: '',
  })

  const submit: FormEventHandler = (e) => {
    e.preventDefault()

    post(two_factor_challenge_store_path())
  }

  return (
    <GuestLayout>
      <Head title="Two factor authentication" />

      <div className="mb-4 text-sm text-muted-foreground">
        Enter the code from your authenticator app to finish signing in.
      </div>

      <form onSubmit={submit}>
        <div>
          <Label htmlFor="code">Code</Label>

          <Input
            id="code"
            name="code"
            value={data.code}
            className="mt-1 block w-full"
            inputMode="numeric"
            autoComplete="one-time-code"
            autoFocus
            onChange={(e) => setData('code', e.target.value)}
          />

          <InputError message={errors.code} className="mt-2" />
        </div>

        <div className="mt-4">
          <Label htmlFor="recovery_code">Or a recovery code</Label>

          <Input
            id="recovery_code"
            name="recovery_code"
            value={data.recovery_code}
            className="mt-1 block w-full"
            autoComplete="one-time-code"
            onChange={(e) => setData('recovery_code', e.target.value)}
          />

          <InputError message={errors.recovery_code} className="mt-2" />
        </div>

        <div className="flex items-center justify-end mt-4">
          <Button className="ms-4" disabled={processing}>
            Continue
          </Button>
        </div>
      </form>
    </GuestLayout>
  )
}
