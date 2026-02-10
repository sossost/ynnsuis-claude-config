# Security Guidelines

Security is not a feature — it's a constraint that applies to every line of code.
Never ship code that you wouldn't trust with your own data.

---

## 1. Pre-Commit Checklist

Before ANY commit, verify all items:

- [ ] No hardcoded secrets (API keys, passwords, tokens, connection strings)
- [ ] No `.env` files or credentials in the commit
- [ ] All user inputs validated and sanitized
- [ ] SQL uses parameterized queries
- [ ] HTML output is sanitized (XSS prevention)
- [ ] Authentication checked on every protected route
- [ ] Authorization verified — correct role/permission for the action
- [ ] Error messages reveal nothing about internals
- [ ] Rate limiting on public-facing endpoints
- [ ] Sensitive data not logged (passwords, tokens, PII)

---

## 2. Secret Management

### Environment Variables

```typescript
// NEVER: Hardcoded anywhere in source
const apiKey = "sk-proj-xxxxx"
const dbUrl = "postgres://user:pass@host/db"
const jwtSecret = "my-secret-key"

// ALWAYS: From environment, with validation at startup
const config = {
  apiKey: requireEnv('API_KEY'),
  dbUrl: requireEnv('DATABASE_URL'),
  jwtSecret: requireEnv('JWT_SECRET'),
} as const

function requireEnv(key: string): string {
  const value = process.env[key]
  if (value == null || value === '') {
    throw new Error(`Missing required environment variable: ${key}`)
  }
  return value
}
```

### Rules
- `.env*` in `.gitignore` before first commit — no exceptions
- Use platform secret managers in production (Vercel, AWS SSM, Vault)
- Rotate secrets immediately if exposed, even briefly
- Never log secrets, even at debug level
- Use different secrets per environment (dev/staging/prod)

---

## 3. Input Validation

Validate everything that crosses a trust boundary: user input, API parameters, URL params, file uploads, webhook payloads.

```typescript
import { z } from 'zod'

// Define strict schemas
const CreateOrderSchema = z.object({
  productId: z.string().uuid(),
  quantity: z.number().int().min(1).max(100),
  couponCode: z.string().max(20).optional(),
})

// Validate at the boundary — reject early
app.post('/orders', async (req, res) => {
  const result = CreateOrderSchema.safeParse(req.body)
  if (!result.success) {
    return res.status(400).json({
      success: false,
      error: 'Invalid input',
      details: result.error.flatten(),
    })
  }

  // result.data is now typed and safe
  const order = await createOrder(result.data)
  return res.json({ success: true, data: order })
})
```

---

## 4. Common Vulnerabilities

### SQL Injection

```typescript
// WRONG: String concatenation — attacker controls the query
const query = `SELECT * FROM users WHERE email = '${email}'`
const query = `DELETE FROM orders WHERE id = ${req.params.id}`

// CORRECT: Parameterized queries — values are escaped by the driver
const user = await db.query('SELECT * FROM users WHERE email = $1', [email])
const result = await prisma.user.findUnique({ where: { email } })
```

### XSS (Cross-Site Scripting)

```typescript
// WRONG: Injecting user content as raw HTML
element.innerHTML = userComment
return <div dangerouslySetInnerHTML={{ __html: userInput }} />

// CORRECT: React escapes by default — just use JSX
return <div>{userComment}</div>

// If raw HTML is unavoidable (markdown rendering, rich text):
import DOMPurify from 'dompurify'
const clean = DOMPurify.sanitize(rawHtml)
return <div dangerouslySetInnerHTML={{ __html: clean }} />
```

### CSRF (Cross-Site Request Forgery)

- Use `SameSite=Strict` or `SameSite=Lax` on cookies
- Validate `Origin` header on state-changing requests
- Use CSRF tokens for form submissions outside SPAs
- Prefer token-based auth (Bearer) over cookies for APIs

### Authentication

```typescript
// Password hashing — NEVER use MD5, SHA1, or plain text
import bcrypt from 'bcrypt'

const SALT_ROUNDS = 12

async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, SALT_ROUNDS)
}

async function verifyPassword(password: string, hash: string): Promise<boolean> {
  return bcrypt.compare(password, hash)
}
```

- Use `httpOnly`, `secure`, `sameSite` flags on session cookies
- Implement token expiry and refresh rotation
- Lock accounts after repeated failed attempts
- Validate JWT signature AND claims (exp, iss, aud) on every request

### Authorization

```typescript
// WRONG: Only checking on the frontend
{user.role === 'admin' && <DeleteButton />}
// Attacker can call the API directly — UI hiding is not security

// CORRECT: Enforce on the API layer
async function deleteUser(requesterId: string, targetId: string) {
  const requester = await getUser(requesterId)
  if (requester.role !== 'admin') {
    throw new ForbiddenError('Only admins can delete users')
  }
  await userRepo.delete(targetId)
}
```

- Check permissions on every API endpoint, not just the UI
- Use middleware for role-based access control
- Implement resource-level authorization (user can only edit their own data)
- Log unauthorized access attempts

---

## 5. Frontend Security

### Content Security Policy (CSP)

```typescript
// next.config.js — restrict what can execute on the page
const securityHeaders = [
  {
    key: 'Content-Security-Policy',
    value: "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline';",
  },
  { key: 'X-Content-Type-Options', value: 'nosniff' },
  { key: 'X-Frame-Options', value: 'DENY' },
  { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
]
```

### Sensitive Data in the Browser

- Never store secrets in `localStorage` or `sessionStorage`
- Never expose API keys in client-side bundles (`NEXT_PUBLIC_` prefix = public)
- Use `httpOnly` cookies for session tokens — JavaScript cannot read them
- Sanitize all data before rendering

---

## 6. Dependency Security

- Run `npm audit` or `pnpm audit` regularly
- Keep dependencies updated — automated with Dependabot or Renovate
- Audit new dependencies before adding: check maintainers, download count, last update
- Pin major versions to avoid unexpected breaking changes
- Prefer well-maintained, widely-used packages over obscure ones

---

## 7. Security Response Protocol

If a security vulnerability is discovered:

1. **STOP** current work immediately
2. Run the **security-reviewer** agent for full assessment
3. Fix **CRITICAL** issues before any other work continues
4. Rotate any potentially exposed secrets
5. Audit the codebase for similar patterns
6. Document the vulnerability and fix in a decision record
7. Add a regression test that verifies the fix
