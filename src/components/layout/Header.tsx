'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { useEffect, useState } from 'react'
import { User } from '@supabase/supabase-js'
import { signOut } from '@/app/auth/actions'
import { Bell, Bookmark, Share2, Search, LogOut, User as UserIcon } from 'lucide-react'

export default function Header() {
  const pathname = usePathname()
  const [user, setUser] = useState<User | null>(null)
  const [showUserMenu, setShowUserMenu] = useState(false)
  const [searchQuery, setSearchQuery] = useState('')

  useEffect(() => {
    const supabase = createClient()

    supabase.auth.getUser().then(({ data: { user } }) => {
      setUser(user)
    })

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null)
    })

    return () => subscription.unsubscribe()
  }, [])

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault()
    // 検索処理
    window.location.href = `/?q=${encodeURIComponent(searchQuery)}`
  }

  const getUserInitial = () => {
    const email = user?.email || ''
    return email.charAt(0).toUpperCase()
  }

  return (
    <header className="sticky top-0 z-50 bg-white border-b border-gray-200">
      <div className="container mx-auto px-4">
        {/* メインヘッダー */}
        <div className="flex h-16 items-center justify-between">
          {/* ロゴ */}
          <Link href="/" className="flex items-center space-x-2">
            <div className="h-8 w-8 rounded-full bg-primary flex items-center justify-center">
              <span className="text-white text-lg font-bold">🌟</span>
            </div>
            <span className="text-2xl font-bold text-primary hidden sm:inline">
              hoshipad
            </span>
          </Link>

          {/* デスクトップナビゲーション */}
          <nav className="hidden md:flex items-center space-x-6">
            <Link
              href="/"
              className={`text-sm font-medium transition-colors hover:text-primary ${
                pathname === '/' ? 'text-primary' : 'text-gray-700'
              }`}
            >
              ホーム
            </Link>
            <Link
              href="/shopping-list"
              className={`text-sm font-medium transition-colors hover:text-primary ${
                pathname === '/shopping-list' ? 'text-primary' : 'text-gray-700'
              }`}
            >
              買い物リスト
            </Link>
            <Link
              href="/history"
              className={`text-sm font-medium transition-colors hover:text-primary ${
                pathname === '/history' ? 'text-primary' : 'text-gray-700'
              }`}
            >
              履歴
            </Link>
          </nav>

          {/* 右側アイコン群 */}
          <div className="flex items-center space-x-2">
            {/* 共有ヘルプ */}
            <button
              className="p-2 rounded-full hover:bg-gray-100 transition-colors hidden sm:block"
              title="iOSで共有する方法"
            >
              <Share2 className="h-5 w-5 text-gray-500" />
            </button>

            {/* ブックマークレット */}
            <button
              className="p-2 rounded-full hover:bg-gray-100 transition-colors hidden sm:block"
              title="ブックマークレットを追加"
            >
              <Bookmark className="h-5 w-5 text-gray-500" />
            </button>

            {/* 通知 */}
            <button className="p-2 rounded-full hover:bg-gray-100 transition-colors hidden sm:block">
              <Bell className="h-5 w-5 text-gray-500" />
            </button>

            {/* ユーザーメニュー or ログインボタン */}
            {user ? (
              <div className="relative">
                <button
                  onClick={() => setShowUserMenu(!showUserMenu)}
                  className="h-9 w-9 rounded-full bg-gradient-to-br from-primary to-orange-500 text-white font-medium flex items-center justify-center shadow-lg hover:shadow-xl transition-shadow"
                >
                  {getUserInitial()}
                </button>

                {showUserMenu && (
                  <>
                    <div
                      className="fixed inset-0 z-10"
                      onClick={() => setShowUserMenu(false)}
                    />
                    <div className="absolute right-0 mt-2 w-64 bg-white rounded-xl shadow-lg border border-gray-200 z-20 overflow-hidden">
                      {/* ユーザー情報ヘッダー */}
                      <div className="bg-gray-50 p-4 border-b border-gray-200">
                        <div className="flex items-center space-x-3">
                          <div className="h-12 w-12 rounded-full bg-gradient-to-br from-primary to-orange-500 text-white font-medium flex items-center justify-center text-lg">
                            {getUserInitial()}
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className="text-sm font-medium text-gray-900 truncate">
                              ユーザー
                            </p>
                            <p className="text-xs text-gray-500 truncate">
                              {user.email}
                            </p>
                          </div>
                        </div>
                      </div>

                      {/* メニュー項目 */}
                      <div className="py-1">
                        <Link
                          href="/profile"
                          className="flex items-center px-4 py-3 hover:bg-gray-50 transition-colors"
                          onClick={() => setShowUserMenu(false)}
                        >
                          <div className="h-9 w-9 rounded-lg bg-primary-50 flex items-center justify-center mr-3">
                            <UserIcon className="h-5 w-5 text-primary" />
                          </div>
                          <span className="text-sm text-gray-900">プロフィール</span>
                        </Link>

                        <form action={signOut}>
                          <button
                            type="submit"
                            className="w-full flex items-center px-4 py-3 hover:bg-red-50 transition-colors text-left"
                          >
                            <div className="h-9 w-9 rounded-lg bg-red-50 flex items-center justify-center mr-3">
                              <LogOut className="h-5 w-5 text-red-500" />
                            </div>
                            <span className="text-sm text-red-500">サインアウト</span>
                          </button>
                        </form>
                      </div>
                    </div>
                  </>
                )}
              </div>
            ) : (
              <Link
                href="/auth/login"
                className="px-5 py-2 rounded-full bg-gradient-to-r from-primary to-orange-500 text-white text-sm font-bold shadow-lg hover:shadow-xl transition-all"
              >
                ログイン
              </Link>
            )}
          </div>
        </div>

        {/* 検索バー */}
        <div className="pb-3">
          <form onSubmit={handleSearch} className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="料理名・食材で検索"
              className="w-full pl-10 pr-4 py-2.5 bg-gray-100 rounded-full border-0 focus:outline-none focus:ring-2 focus:ring-primary focus:bg-white transition-all"
            />
          </form>
        </div>
      </div>
    </header>
  )
}
