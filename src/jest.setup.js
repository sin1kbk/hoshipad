import '@testing-library/jest-dom'

// Mock Web APIs for Node.js environment
if (typeof global.Request === 'undefined') {
  global.Request = class Request {
    constructor(input, init = {}) {
      this.url = typeof input === 'string' ? input : input.url
      this.method = init.method || 'GET'
      this.headers = new Headers(init.headers || {})
      this.body = init.body || null
      this.bodyUsed = false
    }

    async json() {
      if (this.bodyUsed) {
        throw new TypeError('Body already read')
      }
      this.bodyUsed = true
      return this.body ? JSON.parse(this.body) : {}
    }

    clone() {
      return new Request(this.url, {
        method: this.method,
        headers: this.headers,
        body: this.body,
      })
    }
  }
}

if (typeof global.Response === 'undefined') {
  global.Response = class Response {
    constructor(body, init = {}) {
      this.body = body
      this.status = init.status || 200
      this.statusText = init.statusText || 'OK'
      this.headers = new Headers(init.headers || {})
      this.ok = this.status >= 200 && this.status < 300
    }

    async json() {
      return typeof this.body === 'string' ? JSON.parse(this.body) : this.body
    }

    async text() {
      return typeof this.body === 'string' ? this.body : JSON.stringify(this.body)
    }
  }
}

if (typeof global.Headers === 'undefined') {
  global.Headers = class Headers {
    constructor(init = {}) {
      this._headers = {}
      if (init instanceof Headers) {
        init.forEach((value, key) => {
          this._headers[key.toLowerCase()] = value
        })
      } else if (init) {
        Object.entries(init).forEach(([key, value]) => {
          this._headers[key.toLowerCase()] = value
        })
      }
    }

    get(name) {
      return this._headers[name.toLowerCase()] || null
    }

    set(name, value) {
      this._headers[name.toLowerCase()] = value
    }

    has(name) {
      return name.toLowerCase() in this._headers
    }

    forEach(callback) {
      Object.entries(this._headers).forEach(([key, value]) => {
        callback(value, key)
      })
    }
  }
}

// Mock Next.js router
jest.mock('next/navigation', () => ({
  useRouter: jest.fn(() => ({
    push: jest.fn(),
    replace: jest.fn(),
    prefetch: jest.fn(),
    back: jest.fn(),
  })),
  useSearchParams: jest.fn(() => new URLSearchParams()),
  usePathname: jest.fn(() => '/'),
}))

// Mock Next.js server
jest.mock('next/server', () => {
  const actual = jest.requireActual('next/server')
  return {
    ...actual,
    NextRequest: class NextRequest extends global.Request {
      constructor(input, init = {}) {
        super(input, init)
        this.nextUrl = {
          searchParams: new URLSearchParams(
            typeof input === 'string' ? new URL(input).search : input.search
          ),
        }
      }
    },
    NextResponse: {
      json: (body, init = {}) => {
        return new global.Response(JSON.stringify(body), {
          ...init,
          headers: {
            'Content-Type': 'application/json',
            ...init.headers,
          },
        })
      },
      next: (init = {}) => {
        return new global.Response(null, init)
      },
    },
  }
})

// Mock environment variables
process.env.NEXT_PUBLIC_SUPABASE_URL = 'https://test.supabase.co'
process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = 'test-key'
