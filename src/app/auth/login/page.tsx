'use client'

import { useActionState } from 'react'
import { signIn } from '../actions'
import Link from 'next/link'

const initialState = {
  error: '',
}

export default function LoginPage() {
  const [state, formAction] = useActionState(signIn, initialState)

  return (
    <div className="flex min-h-screen items-center justify-center px-4 py-12">
      <div className="w-full max-w-md space-y-8">
        <div className="text-center">
          <h2 className="text-3xl font-bold text-primary">ログイン</h2>
          <p className="mt-2 text-sm text-gray-600">
            hoshipadへようこそ
          </p>
        </div>

        <form className="mt-8 space-y-6" action={formAction}>
           {state?.error && (
            <div className="rounded-md bg-red-50 p-4">
              <div className="flex">
                <div className="ml-3">
                  <h3 className="text-sm font-medium text-red-800">
                    ログインエラー
                  </h3>
                  <div className="mt-2 text-sm text-red-700">
                    <p>{state.error}</p>
                  </div>
                </div>
              </div>
            </div>
          )}
          <div className="space-y-4 rounded-md shadow-sm">
            <div>
              <label htmlFor="email" className="block text-sm font-medium text-gray-700">
                メールアドレス
              </label>
              <input
                id="email"
                name="email"
                type="email"
                autoComplete="email"
                required
                className="mt-1 block w-full rounded-lg border border-gray-300 px-3 py-2 shadow-sm focus:border-primary focus:outline-none focus:ring-primary"
              />
            </div>

            <div>
              <label htmlFor="password" className="block text-sm font-medium text-gray-700">
                パスワード
              </label>
              <input
                id="password"
                name="password"
                type="password"
                autoComplete="current-password"
                required
                className="mt-1 block w-full rounded-lg border border-gray-300 px-3 py-2 shadow-sm focus:border-primary focus:outline-none focus:ring-primary"
              />
            </div>
          </div>

          <div className="flex items-center justify-between">
            <div className="text-sm">
              <Link href="/auth/reset-password" className="text-primary hover:text-primary-600">
                パスワードを忘れた場合
              </Link>
            </div>
          </div>

          <button
            type="submit"
            className="w-full rounded-lg bg-primary px-4 py-2 text-white hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-primary focus:ring-offset-2"
          >
            ログイン
          </button>

          <div className="text-center text-sm">
            <span className="text-gray-600">アカウントをお持ちでない場合は</span>{' '}
            <Link href="/auth/signup" className="text-primary hover:text-primary-600">
              新規登録
            </Link>
          </div>
        </form>
      </div>
    </div>
  )
}
