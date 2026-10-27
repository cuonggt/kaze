import { Head, useForm } from '@inertiajs/react'
import { FormEventHandler } from 'react'
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout'
import SettingsLayout from '@/Layouts/SettingsLayout'
import Heading from '@/Components/Heading'
import InputError from '@/Components/InputError'
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

const breadcrumbs: BreadcrumbItem[] = [
  {
    title: 'Two factor settings',
    href: two_factor_edit_path(),
  },
]

type Props = {
  enabled: boolean
  pending: boolean
  qrCode: string | null
  secret: string | null
  recoveryCodes: string[]
}

export default function TwoFactor({ enabled, pending, qrCode, secret, recoveryCodes }: Props) {
  return (
    <AuthenticatedLayout breadcrumbs={breadcrumbs}>
      <Head title="Two factor settings" />

      <SettingsLayout>
        <div className="space-y-6">
          <Heading
            variant="small"
            title="Two factor authentication"
            description="Add a second step to signing in, using an authenticator app"
          />

          {enabled ? (
            <Enabled recoveryCodes={recoveryCodes} />
          ) : pending ? (
            <Confirming qrCode={qrCode} secret={secret} />
          ) : (
            <Disabled />
          )}
        </div>
      </SettingsLayout>
    </AuthenticatedLayout>
  )
}

function Disabled() {
  const { post, processing } = useForm({})

  const submit: FormEventHandler = (e) => {
    e.preventDefault()

    post(two_factor_store_path())
  }

  return (
    <>
      <p className="text-sm text-muted-foreground">
        Two factor authentication is off. Turn it on and you will be asked for a code from your authenticator app each
        time you sign in.
      </p>

      <form onSubmit={submit}>
        <Button disabled={processing}>Turn on two factor authentication</Button>
      </form>
    </>
  )
}

function Confirming({ qrCode, secret }: { qrCode: string | null; secret: string | null }) {
  const { data, setData, patch, processing, errors } = useForm({ code: '' })

  const submit: FormEventHandler = (e) => {
    e.preventDefault()

    patch(two_factor_update_path())
  }

  return (
    <>
      <p className="text-sm text-muted-foreground">
        Scan this with your authenticator app, then enter the code it shows to finish turning it on.
      </p>

      {qrCode && (
        <div
          className="w-44 rounded-lg border border-sidebar-border/70 bg-white p-2 dark:border-sidebar-border"
          dangerouslySetInnerHTML={{ __html: qrCode }}
        />
      )}

      <p className="text-sm text-muted-foreground">
        Cannot scan it? Enter this key instead:{' '}
        <code className="rounded bg-muted px-1.5 py-0.5 font-mono text-xs text-foreground">{secret}</code>
      </p>

      <form onSubmit={submit} className="space-y-6">
        <div>
          <Label htmlFor="code">Code</Label>

          <Input
            id="code"
            name="code"
            value={data.code}
            className="mt-1 block w-full max-w-xs"
            inputMode="numeric"
            autoComplete="one-time-code"
            autoFocus
            onChange={(e) => setData('code', e.target.value)}
          />

          <InputError message={errors.code} className="mt-2" />
        </div>

        <Button disabled={processing}>Confirm</Button>
      </form>
    </>
  )
}

function Enabled({ recoveryCodes }: { recoveryCodes: string[] }) {
  const regenerate = useForm({})
  const disable = useForm({ password: '' })

  const submitRegenerate: FormEventHandler = (e) => {
    e.preventDefault()

    regenerate.post(two_factor_recovery_codes_path())
  }

  const submitDisable: FormEventHandler = (e) => {
    e.preventDefault()

    disable.delete(two_factor_destroy_path())
  }

  return (
    <>
      <p className="text-sm text-muted-foreground">
        Two factor authentication is on. You will be asked for a code each time you sign in.
      </p>

      <div className="space-y-3 rounded-xl border border-sidebar-border/70 p-4 dark:border-sidebar-border">
        <div className="text-sm font-medium">Recovery codes</div>

        <p className="text-sm text-muted-foreground">
          Keep these somewhere safe. Each one can be used once to sign in if you cannot reach your authenticator app.
        </p>

        <ul className="grid grid-cols-2 gap-1 font-mono text-xs">
          {recoveryCodes.map((recoveryCode) => (
            <li key={recoveryCode}>{recoveryCode}</li>
          ))}
        </ul>

        <form onSubmit={submitRegenerate}>
          <Button variant="outline" disabled={regenerate.processing}>
            Generate new codes
          </Button>
        </form>
      </div>

      <form onSubmit={submitDisable} className="space-y-6">
        <div>
          <Label htmlFor="password">Current password</Label>

          <Input
            id="password"
            type="password"
            name="password"
            value={disable.data.password}
            className="mt-1 block w-full max-w-xs"
            autoComplete="current-password"
            onChange={(e) => disable.setData('password', e.target.value)}
          />

          <InputError message={disable.errors.password} className="mt-2" />
        </div>

        <Button variant="destructive" disabled={disable.processing}>
          Turn off two factor authentication
        </Button>
      </form>
    </>
  )
}
