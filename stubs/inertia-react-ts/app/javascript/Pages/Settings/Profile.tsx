import { Head } from '@inertiajs/react'
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout'
import SettingsLayout from '@/Layouts/SettingsLayout'
import Heading from '@/Components/Heading'
import DeleteUserForm from './Partials/DeleteUserForm'
import UpdateProfileInformationForm from './Partials/UpdateProfileInformationForm'
import { profile_edit_path } from '@/routes'
import { BreadcrumbItem, PageProps } from '@/types'

const breadcrumbs: BreadcrumbItem[] = [
  {
    title: 'Profile settings',
    href: profile_edit_path(),
  },
]

export default function Profile({ mustVerifyEmail, status }: PageProps<{ mustVerifyEmail: boolean; status?: string }>) {
  return (
    <AuthenticatedLayout breadcrumbs={breadcrumbs}>
      <Head title="Profile settings" />

      <SettingsLayout>
        <div className="space-y-6">
          <Heading variant="small" title="Profile information" description="Update your name and email address" />
          <UpdateProfileInformationForm mustVerifyEmail={mustVerifyEmail} status={status} />
        </div>

        <div className="space-y-6">
          <Heading variant="small" title="Delete account" description="Delete your account and all of its resources" />
          <DeleteUserForm />
        </div>
      </SettingsLayout>
    </AuthenticatedLayout>
  )
}
