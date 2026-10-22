import { Head } from '@inertiajs/react'
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout'
import SettingsLayout from '@/Layouts/SettingsLayout'
import Heading from '@/Components/Heading'
import UpdatePasswordForm from './Partials/UpdatePasswordForm'
import { password_edit_path } from '@/routes'
import { BreadcrumbItem } from '@/types'

const breadcrumbs: BreadcrumbItem[] = [
  {
    title: 'Password settings',
    href: password_edit_path(),
  },
]

export default function Password() {
  return (
    <AuthenticatedLayout breadcrumbs={breadcrumbs}>
      <Head title="Password settings" />

      <SettingsLayout>
        <div className="space-y-6">
          <Heading
            variant="small"
            title="Update password"
            description="Ensure your account is using a long, random password to stay secure"
          />
          <UpdatePasswordForm />
        </div>
      </SettingsLayout>
    </AuthenticatedLayout>
  )
}
