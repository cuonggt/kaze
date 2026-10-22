import { Head } from '@inertiajs/react'
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout'
import SettingsLayout from '@/Layouts/SettingsLayout'
import Heading from '@/Components/Heading'
import UpdateAppearanceForm from './Partials/UpdateAppearanceForm'
import { appearance_edit_path } from '@/routes'
import { BreadcrumbItem } from '@/types'

const breadcrumbs: BreadcrumbItem[] = [
  {
    title: 'Appearance settings',
    href: appearance_edit_path(),
  },
]

export default function Appearance() {
  return (
    <AuthenticatedLayout breadcrumbs={breadcrumbs}>
      <Head title="Appearance settings" />

      <SettingsLayout>
        <div className="space-y-6">
          <Heading
            variant="small"
            title="Appearance settings"
            description="Update the appearance settings for your account"
          />
          <UpdateAppearanceForm />
        </div>
      </SettingsLayout>
    </AuthenticatedLayout>
  )
}
