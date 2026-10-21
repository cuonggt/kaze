import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout'
import DeleteUserForm from './Partials/DeleteUserForm'
import UpdateAppearanceForm from './Partials/UpdateAppearanceForm'
import UpdatePasswordForm from './Partials/UpdatePasswordForm'
import UpdateProfileInformationForm from './Partials/UpdateProfileInformationForm'
import { Head } from '@inertiajs/react'
import { profile_edit_path } from '@/routes'
import { BreadcrumbItem, PageProps } from '@/types'

const breadcrumbs: BreadcrumbItem[] = [
  {
    title: 'Profile',
    href: profile_edit_path(),
  },
]

export default function Edit({ mustVerifyEmail, status }: PageProps<{ mustVerifyEmail: boolean; status?: string }>) {
  return (
    <AuthenticatedLayout breadcrumbs={breadcrumbs}>
      <Head title="Profile" />

      <div className="flex h-full flex-1 flex-col gap-6 p-4">
        <div className="rounded-xl border border-sidebar-border/70 p-4 sm:p-8 dark:border-sidebar-border">
          <UpdateAppearanceForm className="max-w-xl" />
        </div>

        <div className="rounded-xl border border-sidebar-border/70 p-4 sm:p-8 dark:border-sidebar-border">
          <UpdateProfileInformationForm mustVerifyEmail={mustVerifyEmail} status={status} className="max-w-xl" />
        </div>

        <div className="rounded-xl border border-sidebar-border/70 p-4 sm:p-8 dark:border-sidebar-border">
          <UpdatePasswordForm className="max-w-xl" />
        </div>

        <div className="rounded-xl border border-sidebar-border/70 p-4 sm:p-8 dark:border-sidebar-border">
          <DeleteUserForm className="max-w-xl" />
        </div>
      </div>
    </AuthenticatedLayout>
  )
}
