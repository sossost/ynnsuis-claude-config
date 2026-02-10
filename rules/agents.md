# Agent Orchestration

## Available Agents

| Agent | Role | When to Use |
|-------|------|-------------|
| **planner** | Implementation planning | Complex features, multi-step refactoring |
| **architect** | System design | Architecture decisions, scaling strategy |
| **tdd-guide** | Test-driven development | New features, bug fixes — enforces test-first |
| **code-reviewer** | Code quality review | After writing or modifying code |
| **security-reviewer** | Security analysis | Auth, payments, user input, API endpoints |
| **build-error-resolver** | Fix build errors | Build failures, type errors |
| **e2e-runner** | E2E testing | Critical user flows (Playwright) |
| **refactor-cleaner** | Dead code cleanup | Periodic maintenance, post-migration |
| **doc-updater** | Documentation | Codemap generation, README updates |

## Automatic Agent Triggers

Use agents proactively without waiting for the user to ask:

| Situation | Action |
|-----------|--------|
| Complex feature request received | Launch **planner** |
| Code was just written or modified | Run **code-reviewer** |
| New feature or bug fix starting | Start with **tdd-guide** |
| Architecture question or concern | Consult **architect** |
| Security-sensitive code touched | Run **security-reviewer** |
| Build breaks | Launch **build-error-resolver** |

## Parallel Execution

ALWAYS launch independent agents in parallel:

```
# GOOD: Parallel — 3 agents at once
Agent 1: Security review of auth module
Agent 2: Performance review of cache layer
Agent 3: Type checking of utility functions

# BAD: Sequential when no dependency exists
First agent 1... then agent 2... then agent 3...
```

## Multi-Perspective Analysis

For critical decisions, use multiple agents for diverse viewpoints:

1. **Architect** — Is the design sound?
2. **Security reviewer** — Are there vulnerabilities?
3. **Code reviewer** — Is the code maintainable?

Synthesize their outputs. If agents disagree, present the conflict to the user.

## Agent Model Selection

| Agent | Recommended Model | Reason |
|-------|-------------------|--------|
| planner | Opus | Deep reasoning for planning |
| architect | Opus | Complex system thinking |
| tdd-guide | Sonnet | Good balance of speed and quality |
| code-reviewer | Sonnet | Fast iteration cycles |
| security-reviewer | Opus | Thoroughness matters for security |
| build-error-resolver | Sonnet | Speed-focused error resolution |
| e2e-runner | Sonnet | Practical test generation |
| refactor-cleaner | Haiku | Routine cleanup tasks |
| doc-updater | Haiku | Straightforward documentation |
