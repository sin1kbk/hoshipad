export default function VerifyEmailPage() {
  return (
    <div className="flex min-h-screen items-center justify-center px-4 py-12">
      <div className="w-full max-w-md space-y-8 text-center">
        <div>
          <h2 className="text-3xl font-bold text-primary">メールを確認してください</h2>
          <p className="mt-4 text-gray-600">
            登録いただいたメールアドレスに確認メールを送信しました。
            <br />
            メール内のリンクをクリックして、アカウントを有効化してください。
          </p>
        </div>
      </div>
    </div>
  )
}
