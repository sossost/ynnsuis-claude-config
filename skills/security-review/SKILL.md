---
name: security-review
description: Use this skill when adding authentication, handling user input, working with secrets, creating API endpoints, or implementing payment/sensitive features.
---

# Security Review Skill

Ensures all code follows security best practices and identifies potential vulnerabilities.

## When to Activate

- Implementing authentication or authorization
- Handling user input or file uploads
- Creating new API endpoints
- Working with secrets or credentials
- Implementing payment features
- Storing or transmitting sensitive data
- Integrating third-party APIs

## Security Checklist

### 1. Secrets Management

```typescript
// NEVER: Hardcoded secrets
const apiKey = "sk-xxxxx"
const dbPassword = "password123"

// ALWAYS: Environment variables with validation
function requireEnv(name: string): string {
  const value = process.env[name]
  if (value == null) {
    throw new Error(`Missing required environment variable: ${name}`)
  }
  return value
}

const apiKey = requireEnv('API_KEY')
const dbUrl = requireEnv('DATABASE_URL')
```

**Verification:**
- [ ] No hardcoded API keys, tokens, or passwords
- [ ] All secrets in environment variables
- [ ] `.env.local` in .gitignore
- [ ] No secrets in git history
- [ ] Production secrets in hosting platform

### 2. Input Validation

```typescript
import { z } from 'zod'

const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
  age: z.number().int().min(0).max(150)
})

export async function createUser(input: unknown) {
  const validated = CreateUserSchema.parse(input)
  return await db.users.create(validated)
}
```

**File Upload Validation:**
```typescript
function validateFileUpload(file: File) {
  const MAX_SIZE = 5 * 1024 * 1024  // 5MB

  if (file.size > MAX_SIZE) {
    throw new Error('File too large (max 5MB)')
  }

  const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp']
  if (!ALLOWED_TYPES.includes(file.type)) {
    throw new Error('Invalid file type')
  }

  return true
}
```

**Verification:**
- [ ] All user inputs validated with schemas
- [ ] File uploads restricted (size, type, extension)
- [ ] No direct use of user input in queries
- [ ] Whitelist validation (not blacklist)
- [ ] Error messages don't leak internals

### 3. SQL Injection Prevention

```typescript
// NEVER: String concatenation
const query = `SELECT * FROM users WHERE email = '${userEmail}'`

// ALWAYS: Parameterized queries
const user = await db.query(
  'SELECT * FROM users WHERE email = $1',
  [userEmail]
)

// Or with ORM/query builder
const user = await db.users.findFirst({
  where: { email: userEmail }
})
```

### 4. Authentication & Authorization

```typescript
// Token storage: httpOnly cookies, not localStorage
res.setHeader('Set-Cookie',
  `token=${token}; HttpOnly; Secure; SameSite=Strict; Max-Age=3600`)

// Authorization: verify on every protected route
export async function DELETE(req: Request) {
  const user = await requireAuth(req)

  if (user.id !== targetUserId && user.role !== 'admin') {
    return Response.json({ error: 'Forbidden' }, { status: 403 })
  }

  // Proceed
}
```

**Verification:**
- [ ] Tokens stored in httpOnly cookies (not localStorage)
- [ ] Authorization checks on every protected route
- [ ] Role-based access control implemented
- [ ] Session management is secure
- [ ] Password hashing uses bcrypt/argon2

### 5. XSS Prevention

```typescript
// NEVER: Direct HTML injection
element.innerHTML = userInput

// ALWAYS: Text content or sanitization
element.textContent = userInput

// If HTML is needed:
import DOMPurify from 'dompurify'
element.innerHTML = DOMPurify.sanitize(userInput, {
  ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'p'],
  ALLOWED_ATTR: []
})
```

**CSP Headers:**
```typescript
const securityHeaders = [
  {
    key: 'Content-Security-Policy',
    value: "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:;"
  }
]
```

### 6. CSRF Protection

```typescript
// SameSite cookies
res.setHeader('Set-Cookie',
  `session=${sessionId}; HttpOnly; Secure; SameSite=Strict`)

// CSRF token verification
export async function POST(req: Request) {
  const token = req.headers.get('X-CSRF-Token')
  if (!csrfService.verify(token)) {
    return Response.json({ error: 'Invalid CSRF token' }, { status: 403 })
  }
  // Proceed
}
```

### 7. Rate Limiting

```typescript
import rateLimit from 'express-rate-limit'

// General API rate limit
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,  // 15 minutes
  max: 100,
  message: 'Too many requests'
})

// Stricter limit for expensive operations
const searchLimiter = rateLimit({
  windowMs: 60 * 1000,  // 1 minute
  max: 10,
  message: 'Too many search requests'
})
```

### 8. Sensitive Data Exposure

```typescript
// NEVER: Log sensitive data
console.log('Login:', { email, password })
console.log('Payment:', { cardNumber, cvv })

// ALWAYS: Redact sensitive fields
console.log('Login:', { email, userId })
console.log('Payment:', { last4: card.last4, userId })

// NEVER: Expose internal errors
catch (error) {
  return Response.json({ error: error.message, stack: error.stack })
}

// ALWAYS: Generic error messages
catch (error) {
  console.error('Internal error:', error)
  return Response.json({ error: 'An error occurred' }, { status: 500 })
}
```

### 9. Dependency Security

```bash
npm audit                    # Check for vulnerabilities
npm audit fix               # Fix automatically
npm outdated                # Check for updates
npm ci                      # Reproducible installs in CI
```

- [ ] Dependencies up to date
- [ ] No known vulnerabilities
- [ ] Lock files committed
- [ ] Dependabot or Renovate enabled

## Security Testing

```typescript
test('requires authentication', async () => {
  const response = await fetch('/api/protected')
  expect(response.status).toBe(401)
})

test('requires admin role', async () => {
  const response = await fetch('/api/admin', {
    headers: { Authorization: `Bearer ${userToken}` }
  })
  expect(response.status).toBe(403)
})

test('rejects invalid input', async () => {
  const response = await fetch('/api/users', {
    method: 'POST',
    body: JSON.stringify({ email: 'not-an-email' })
  })
  expect(response.status).toBe(400)
})

test('enforces rate limits', async () => {
  const requests = Array(101).fill(null).map(() => fetch('/api/endpoint'))
  const responses = await Promise.all(requests)
  const rateLimited = responses.filter(r => r.status === 429)
  expect(rateLimited.length).toBeGreaterThan(0)
})
```

## Pre-Deployment Checklist

- [ ] No hardcoded secrets
- [ ] All user inputs validated
- [ ] SQL injection prevented (parameterized queries)
- [ ] XSS prevented (sanitized content)
- [ ] CSRF protection enabled
- [ ] Auth/authz on all protected routes
- [ ] Rate limiting on all endpoints
- [ ] HTTPS enforced in production
- [ ] Security headers configured (CSP, X-Frame-Options)
- [ ] Error messages don't leak internals
- [ ] No sensitive data in logs
- [ ] Dependencies audited and up to date
- [ ] CORS properly configured
- [ ] File uploads validated
