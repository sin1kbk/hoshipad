# Authentication Specification

## 1. Overview
User authentication using Supabase Auth to secure personal recipe data.

## 2. Requirements

### 2.1 Sign Up
- **Route**: `/auth/signup`
- **Fields**: Email, Password (min 6 chars).
- **Process**:
  1. User enters credentials.
  2. Supabase sends confirmation email.
  3. UI shows "Check your email" message.

### 2.2 Login
- **Route**: `/auth/login`
- **Fields**: Email, Password.
- **Process**:
  1. User enters credentials.
  2. On success, redirect to Home (`/`).
  3. On failure, show error message.

### 2.3 Logout
- **Process**: Clears session and redirects to `/auth/login`.

### 2.4 Session Management
- **Middleware**: Protects all routes except `/auth/*` and public API endpoints.
- **Persistence**: Supabase client (`@supabase/ssr`) manages persistent sessions via cookies.

## 3. Implementation
- **Client**: `src/lib/supabase/client.ts`
- **Server**: `src/lib/supabase/server.ts`
- **Middleware**: `src/middleware.ts`
