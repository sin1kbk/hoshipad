'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import HeaderClient from '@/components/layout/HeaderClient'
import { User } from '@supabase/supabase-js'
import { ArrowLeft } from 'lucide-react'

interface EditProfileFormProps {
  user: User
}

export default function EditProfileForm({ user }: EditProfileFormProps) {
  const router = useRouter()
  const [displayName, setDisplayName] = useState(
    user.user_metadata?.display_name || user.email?.split('@')[0] || ''
  )
  const [isLoading, setIsLoading] = useState(false)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)

    try {
      const response = await fetch('/api/profile', {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ display_name: displayName }),
      })

      if (!response.ok) throw new Error('プロフィールの更新に失敗しました')

      router.push('/profile')
      router.refresh()
    } catch (error) {
      alert('プロフィールの更新に失敗しました')
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <>
      <HeaderClient initialUser={null} />
      <main className="container mx-auto max-w-2xl px-4 py-8">
        <button
          onClick={() => router.back()}
          className="mb-6 flex items-center text-gray-700 hover:text-primary"
        >
          <ArrowLeft className="mr-2 h-5 w-5" />
          戻る
        </button>

        <h1 className="mb-8 text-3xl font-bold text-gray-900">
          プロフィール編集
        </h1>

        <form onSubmit={handleSubmit} className="space-y-6">
          {/* 表示名 */}
          <div>
            <label className="mb-2 block text-sm font-medium text-gray-700">
              表示名
            </label>
            <input
              type="text"
              value={displayName}
              onChange={(e) => setDisplayName(e.target.value)}
              className="w-full rounded-lg border border-gray-300 px-3 py-2 focus:border-primary focus:outline-none focus:ring-2 focus:ring-primary"
              required
              minLength={2}
            />
          </div>

          {/* メールアドレス（読み取り専用） */}
          <div>
            <label className="mb-2 block text-sm font-medium text-gray-700">
              メールアドレス
            </label>
            <input
              type="email"
              value={user.email || ''}
              disabled
              className="w-full rounded-lg border border-gray-300 bg-gray-100 px-3 py-2 text-gray-600"
            />
          </div>

          {/* 送信ボタン */}
          <div className="flex justify-end space-x-4">
            <button
              type="button"
              onClick={() => router.back()}
              className="rounded-lg border border-gray-300 px-6 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
            >
              キャンセル
            </button>
            <button
              type="submit"
              disabled={isLoading}
              className="rounded-lg bg-primary px-6 py-2 text-sm font-medium text-white hover:bg-primary/90 disabled:opacity-50"
            >
              {isLoading ? '更新中...' : '更新'}
            </button>
          </div>
        </form>
      </main>
    </>
  )
}
