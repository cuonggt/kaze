import { InputHTMLAttributes } from 'react'

export default function Checkbox({ className = '', ...props }: InputHTMLAttributes<HTMLInputElement>) {
  return (
    <input
      {...props}
      type="checkbox"
      className={`rounded-sm dark:bg-gray-900 border-gray-300 dark:border-gray-700 text-indigo-600 shadow-xs focus:ring-indigo-500 dark:focus:ring-indigo-600 dark:focus:ring-offset-gray-800 ${className}`}
    />
  )
}
