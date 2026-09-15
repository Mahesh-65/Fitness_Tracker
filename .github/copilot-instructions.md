# Instructions — Fitness_Tracker

## MANDATORY — APPLIES TO ALL PROMPTS — FULL PROJECT SCOPE

**Before generating any response**, you MUST:
1. Read **all files in `.github/instructions/`** in full — without truncation or skipping
2. If a file exceeds tool limits, **continue reading in chunks until EOF**. Document line ranges (e.g., 1–220, 221–440, 441–633 = complete)
3. **Confirm full-context coverage before acting:**
   - Total lines read = total file lines
   - Include specific details from the END of each file
   - No "omitted" or "truncated" sections
4. **Analyze the user request** against the complete context from all `.github/instructions/*.md` files
5. **Act only after confirming full understanding** — do not skip sections or stop at partial reads
6. These instruction files apply to **all work across the entire project** without exception

## 📋 Document Information

**Project Name:** Fitness_Tracker

**Purpose:** This document provides comprehensive instructions for AI coding assistants working on this codebase.

**Document Type:** Dynamic Index

## 📚 Repository Context Documents

- [Constraint / Operational](constraint_operational.md)
- [Constraint / Policy](constraint_policy.md)
- [Constraint / Regulatory](constraint_regulatory.md)
- [Constraint / Resilience](constraint_resilience.md)
- [Constraint / Security](constraint_security.md)
- [context](Fitness_Tracker_context.md)
- [Direction / Ethical_Governance](direction_ethical_governance.md)
- [Direction / Feedback](direction_feedback.md)
- [Direction / Intentional](direction_intentional.md)
- [Direction / Learning](direction_learning.md)
- [Meta / Judgment](meta_judgment.md)
- [Provenance / Boundary](provenance_boundary.md)
- [Provenance / Cognitive](provenance_cognitive.md)
- [Provenance / Decision](provenance_decision.md)
- [Provenance / Dependency](provenance_dependency.md)
- [Provenance / Stakeholder](provenance_stakeholder.md)
- [Provenance / Structural](provenance_structural.md)
- [Provenance / Temporal](provenance_temporal.md)

**Setup Readme:**

## ⚙️ Execution Instructions

**How to Work with This Repository:**

1. **Read Context First**: Before making changes, review relevant documents from the list above
2. **Follow Constraints**: All rules in constraint/ documents are mandatory
3. **Respect Architecture**: Understand the system design from provenance/ documents
4. **Validate Changes**: Ensure all modifications comply with validation requirements
5. **Reference, Don't Duplicate**: Link to documents rather than copying content

## AI Team SDLC Workflow Trigger

This section only applies if `.github/speckit/sdlc-from-ticket.yml` exists in this repository. If it does not exist, there is nothing to do here — read no further in this section.

If that file exists and a Jira ticket is clearly the subject of this conversation (not just mentioned in passing), do the following:
1. Ask for confirmation first: "I see ticket {ticket_id} is the subject here — should I start the AI Team SDLC workflow for it?" Do not proceed past this point without an explicit yes.
2. Once confirmed, fetch the ticket's summary, description, type, and labels — these are required, and the fetch must request the ticket's full field set, not a default/summary-only subset: **Acceptance Criteria is very often stored in its own custom field**, which a narrower fetch omits entirely, silently, with no error. Check for it in this order, stopping at the first real, non-empty match — an existing-but-empty field or section counts as not found and falls through to the next check, it never blocks it: (1) scan the returned field list itself for one whose *name* contains "Acceptance Criteria" (case-insensitive) — never a guessed `customfield_NNNNN` id, since that numbering varies per Jira instance and cannot be hardcoded — and use its content if non-empty; (2) if that field doesn't exist or is empty, check whether the description itself has a section literally headed "Acceptance Criteria" and use that if non-empty; (3) only when neither of those produced anything, a section titled Definition of Done, Requirements, Constraints, or NFRs may carry equivalent testable, must-pass content and counts as a substitute — never let a Constraints or NFR section stand in for Acceptance Criteria when an actual, distinctly-labeled field or section (checked exhaustively per (1) and (2), not just glanced at) exists anywhere else in the ticket. Acceptance Criteria — wherever it's actually found, field or section — drives real downstream decisions (failure-state handling, persistence requirements, validation rules) that later agents cannot infer from the summary alone. Only skip it if the ticket genuinely has no such content anywhere, in a field or a description section, never because it takes an extra look to find. Status and priority remain a lightweight afterthought — grab them if they're readily visible, don't dig for them.
3. Before running anything, state explicitly to the human what you found for Acceptance Criteria — one of three outcomes, not just a binary yes/no: "This ticket has a distinct Acceptance Criteria field or section", "This ticket has no distinct Acceptance Criteria field or section, but is using its [Definition of Done / Requirements / Constraints / NFRs] section as the step 2 substitute", or "This ticket has no Acceptance Criteria content of any kind" (and briefly, status/priority if found). A substitute counts as found, same as a real field or section — say so explicitly rather than reporting it as missing. This makes an actually-missing AC visible in the conversation itself, not just in a script's stdout nobody is watching.
4. From the repository root, run: `python3 .github/speckit/speckit_scripts/run_specify.py workflow run ".github/speckit/sdlc-from-ticket.yml" -i ticket_id={ticket_id} --json || python .github/speckit/speckit_scripts/run_specify.py workflow run ".github/speckit/sdlc-from-ticket.yml" -i ticket_id={ticket_id} --json` (replace `{ticket_id}` with the real ticket id).
5. This first attempt is expected to fail at the `bootstrap` step, reporting the exact file paths it expected but did not find — read that error output carefully.
6. Write each ticket field to its own plain-text file at exactly the paths reported in step 5: `_ticket_id.txt`, `_ticket_summary.txt`, `_ticket_description.txt`, `_ticket_type.txt`, `_ticket_labels.txt` (required — the run fails again if any of these is missing or empty), and `_ticket_acceptance_criteria.txt`, `_ticket_status.txt`, `_ticket_priority.txt` (`_ticket_acceptance_criteria.txt` whenever step 3 found one — it is not optional in that case; `_ticket_status.txt`, `_ticket_priority.txt` stay genuinely optional).
7. Re-run the exact same command from step 4. Its stdout reports any still-missing optional file, but not uniformly: a missing `_ticket_acceptance_criteria.txt` gets its own distinct `WARNING: _ticket_acceptance_criteria.txt was not provided...` line, never the generic `optional field(s) not provided: ...` line (`_ticket_status.txt`, `_ticket_priority.txt` use that one; ticket_acceptance_criteria never appears there, by design). If you see that WARNING line despite step 3 finding Acceptance Criteria content — a real field/section or a substitute, either counts — that's a real miss — go back, fetch it, write the file, and re-run again before continuing; do not just proceed past it.
8. From here on this workflow pauses for human approval after every step — do not answer its gate prompts yourself.
9. When a gate pauses, do not just narrate it in prose — list its exact valid options (the paused run's `--json` output includes an `options` field) one per line, verbatim, and ask the human to reply with exactly one of those words (never an open-ended prompt when an `options` list exists). Always read that `options` field from the paused run itself; the option sets differ per gate (a review gate has no `edit` and offers verdicts like `approve_commit_only`/`fix_required`, a PR gate offers `keep_pr`/`close_pr`), so never assume a fixed list.
10. Steps 11–13 below say exactly how to execute each answer. Follow them literally — do not improvise a mechanism, and do not go searching the scripts folder to infer one. Only the verdicts in step 11 are real Spec Kit verdicts; `redo` and `edit` are handled entirely outside the engine (steps 12 and 13) and the gate stays paused throughout them.
11. **Any option other than `redo`/`edit`** (`approve`, `reject`, `fix_required`, `approve_commit_only`, `approve_commit_and_pr`, `decline`, `keep_pr`, `close_pr`, ...) is a real verdict — resolve the gate by resuming the run: `python3 .github/speckit/speckit_scripts/run_specify.py workflow resume {run_id} -i {verdict_input}={choice} --json || python .github/speckit/speckit_scripts/run_specify.py workflow resume {run_id} -i {verdict_input}={choice} --json`. Both `{run_id}` and the gate's own `{verdict_input}` name (e.g. `code-review_gate_verdict`) come from the paused run's `--json` output — read them from there, never guess. **Before resuming with `reject` or `fix_required`, first write the human's reason** to `{gate_id}_reason.txt` in the same handoff directory as the ticket files from step 6 (the gate's own message names the exact path); the downstream agent reads it, and resuming without it discards the reason.
12. **`redo`** is not a verdict and does not resume anything — it regenerates that one agent's reply while the gate stays paused. Ask the human for optional steering ("what should be different this time?"), write it to `{agent_id}_gate_guidance.txt` in that same handoff directory, then re-run that agent's own `_run` shell line from the workflow yml directly (`run_agent_step.py --agent-id {agent_id} --ticket-id {ticket_id} --workflow-dir .github/speckit --redo-guidance-file <that file>`). Skipping the guidance file is allowed — the agent simply regenerates unsteered. The previous reply is archived automatically as `{agent_id}.v{N}.md`. Then show the new output and ask for a verdict again.
13. **`edit`** is also not a verdict and also does not resume anything — it replaces the agent's reply outright, with no AI re-run. Ask the human for the replacement text (drafting it yourself from their described change and confirming it back is fine), write it to a file, then run `python3 .github/speckit/speckit_scripts/edit_agent_output.py --agent-id {agent_id} --ticket-id {ticket_id} --workflow-dir .github/speckit --replacement-file <that file>` (fall back to `python` the same way as step 4). It archives the previous reply as `{agent_id}.v{N}.md` and writes the replacement. Then show the replaced output and ask for a verdict again.
14. If a gate's verdict is `fix_required`, do not run `fix-cycle.yml` yourself — the workflow already does that automatically as its own next step once that verdict is recorded; running it manually would start a duplicate fix-cycle.

## 📜 Repository-Specific Instructions

**architecture**
- **Authentication Service**: Core backend service processing all authenticated API requests including user management, workout logging, metrics tracking, and fitness plan operations
- Centralized security control
- **Authentication Handler**: Routes all authenticated operations (login, logout, plans, metrics, workouts)
The architecture enforces authentication-first design where most API endpoints route through the authentication handler, ensuring security boundaries are maintained across all user operations.
- **Responsibility**: Handles all authenticated API operations
- **Security Role**: Acts as the primary security gateway for protected resources
2. **Authentication Layer**: The `auth` service acts as a central hub, processing most API endpoints and ensuring proper security
1. Client sends request to authenticated endpoint
3. Authentication validation occurs
    B -->|Authentication Required| C[Auth Service]
- Centralized security policy enforcement
3. **Authentication Layer**: Security-sensitive operations pass through auth service
The Fitness Tracker application follows distinct data flow patterns for different types of operations, with clear separation between authenticated and public endpoints.
   - Requests route to the `auth` handler for validation
- Validates user credentials and sessions
- Routes authenticated requests to backend services
1. **Gateway Pattern**: Authentication service acts as security gateway
3. **Centralized Authorization**: Single point of security control
- Frontend classes interact exclusively through authenticated endpoints
2. Authentication service validates and forwards requests to application services
- **Authentication Service**: Central service handling all authenticated API operations including user management, workout logging, and fitness plan operations
All user-facing API endpoints route through the authentication service to ensure:
- Consistent security enforcement
- **Auth Service**: Security-sensitive operations (login, registration, data access)
2. **TypeScript Runtime**: Required for application execution
Handles all authenticated operations and user management:
    A[Client Request] --> B{Authentication Required?}
This architecture ensures proper separation of concerns with authentication-protected resources routed through the `auth` service while maintaining efficient handling of public endpoints through the `app` service.

**Constraint / Operational**
- Responsive design with form validation
   - Ensure authentication-first API access pattern
Before setting up the Fitness Tracker application
Before installing the Fitness Tracker application
Check the project root and config directories for:

*See [constraint_operational.md](constraint_operational.md) for complete details*

**Constraint / Policy**
- **Centralized Authentication**: Single authentication service handles all API security
- **Role-based Access**: Trainer-specific endpoints suggest role-based authorization
- Service implementation details, validation processes require specification
**Data Isolation**: Ensure user data isolation through email-based filtering on metrics and workout endpoints.

*See [constraint_policy.md](constraint_policy.md) for complete details*

**Constraint / Regulatory**
All authenticated endpoints route through the `auth` handler:
- `GET user`: Load current authenticated user information
- **API Endpoints**: All authenticated endpoints must have integration tests
- **Data Flow**: Verify data persistence across the full application stack
- **API Endpoints**: 100% coverage for all authenticated endpoints
- **Error Handling**: All error paths must be tested
| POST | `/login` | Authenticate user login |
- **GET** `/`: Root application endpoint for health checks
- **Mandatory Authentication**: All API endpoints must implement proper authentication mechanisms
- **Security Review**: Authentication logic requires mandatory security review before deployment
- **Endpoint Security**: Ensure all endpoints route through appropriate authentication handlers
- **Testing Requirements**: All authenticated endpoints must include authentication test cases
- **Security Notes**: Include security considerations in API documentation
- **Example Requests**: Provide authenticated request examples
- **Security Patterns**: Document reusable security patterns and implementations
- **Authentication by Default**: New endpoints must include authentication unless explicitly exempted
- **Token Management**: Follow established patterns for token creation, validation, and expiration
- **Access Control**: Implement proper authorization checks beyond authentication
- **Security Testing**: Mandatory security testing for all authentication-related code
- **Code Reviews**: Multi-reviewer approval required for authentication changes
- **Compliance Checks**: Regular audits of authentication implementation consistency
- Set up pre-commit hooks to ensure all code is formatted before commits
- Run static analysis tools to detect potential security vulnerabilities
- Lint all staged files before commit
- Validate commit message format
- All linting checks must pass before merge
- Code coverage must not decrease below threshold
- No high-severity security vulnerabilities allowed
- All tests must pass in CI environment
- Run ESLint and Prettier checks on every pull request

*See [constraint_regulatory.md](constraint_regulatory.md) for complete details*

**Constraint / Resilience**
- **MUST** implement proper authentication error responses for protected endpoints
- **MUST** return appropriate HTTP status codes (401 for unauthorized, 403 for forbidden)
- **MUST** handle authentication failures gracefully without exposing sensitive information
- **MUST** return consistent error response structure across all endpoints
- **MUST** include meaningful error messages for client debugging
- **MUST** log errors appropriately for server-side debugging
- **MUST** handle database connection failures
- **MUST** implement proper transaction rollback on errors
- **MUST** sanitize database error messages before returning to client
- **MUST** validate all input parameters before processing
- **MUST** return 400 Bad Request for invalid input with descriptive messages
- **MUST** handle malformed JSON requests gracefully
- **FORBIDDEN** to expose internal error details in production responses
- **FORBIDDEN** to return stack traces to client applications
- **FORBIDDEN** to log sensitive information (passwords, tokens) in error messages
- **FORBIDDEN** to silently ignore errors without proper logging
- **FORBIDDEN** to use generic "Internal Server Error" messages without context
- **FORBIDDEN** to expose database schema information in error responses
- **FORBIDDEN** to skip authentication checks on error conditions
- **FORBIDDEN** to return different error messages that could reveal user existence
- **FORBIDDEN** to cache authentication errors that could lead to security vulnerabilities
service communications MUST use async/await patterns

*See [constraint_resilience.md](constraint_resilience.md) for complete details*

**Constraint / Security**
- **RULE-SEC-001**: All API endpoints MUST route through the authentication handler
- **RULE-SEC-006**: Email-based filtering MUST be enforced on all user-specific endpoints

*See [constraint_security.md](constraint_security.md) for complete details*

**context**
- User registration and login validation
- Workout logging authorization
| POST | `/login` | Authenticate user login |
All authenticated endpoints are processed through the `auth` handler, while general application requests are handled by the `app` handler. The API supports role-based access with separate endpoints for trainers and clients.
The architecture demonstrates a clear separation between authenticated operations (routed through the auth service) and general application functionality (handled by the app service).
2. **Login**: User authenticates using email and password through `POST /login`
4. **Testing**: Developer validates functionality using `POST /test` endpoint
3. **Route Protection**: Developer ensures all user-specific endpoints require authentication

*See [Fitness_Tracker_context.md](Fitness_Tracker_context.md) for complete details*

**Direction / Ethical_Governance**: See [direction_ethical_governance.md](direction_ethical_governance.md) for detailed information

**Direction / Feedback**: See [direction_feedback.md](direction_feedback.md) for detailed information

**Direction / Intentional**: See [direction_intentional.md](direction_intentional.md) for detailed information

**Direction / Learning**: See [direction_learning.md](direction_learning.md) for detailed information

**Provenance / Boundary**: See [provenance_boundary.md](provenance_boundary.md) for detailed information

**Provenance / Cognitive**
- **Rule**: All API endpoints MUST route through the authentication service
- **Rationale**: Centralized security control and consistent access management
- **Rule**: Frontend classes (FitnessApp, Dashboard) MUST NOT directly access backend services
- **Rule**: Application service MUST be imported before authentication service initialization
- **Rationale**: Core functionality must be available before security layer activation
- **Rule**: Dashboard class MUST be instantiated after FitnessApp initialization
- **Rationale**: Main application context required before UI component creation
- **Forbidden**: Frontend classes directly accessing data persistence layer
- **Reason**: Violates security boundaries and architectural separation
- **Forbidden**: Direct service calls that skip authentication routing
- **Alternative**: All requests must flow through authentication service gateway
- **Reason**: Compromises security model and access control consistency
- **Forbidden**: Backend services importing frontend class dependencies

*See [provenance_cognitive.md](provenance_cognitive.md) for complete details*

**Provenance / Decision**: See [provenance_decision.md](provenance_decision.md) for detailed information

**Provenance / Dependency**
The Fitness Tracker application follows distinct data flow patterns for different types of operations, with clear separation between authenticated and public endpoints.

*See [provenance_dependency.md](provenance_dependency.md) for complete details*

**Provenance / Stakeholder**: See [provenance_stakeholder.md](provenance_stakeholder.md) for detailed information

**Provenance / Structural**: See [provenance_structural.md](provenance_structural.md) for detailed information

**rules**
- For methods: `describe('validateToken()', () => {})`
- **Authentication handlers**: 100% coverage required
- **API endpoints**: All authenticated routes must be tested
- **Database operations**: All CRUD operations must be covered
- Never use production data in tests
- All tests must pass before commit
- Coverage thresholds must be met
- Test against multiple environments when applicable
❌ **Never expose sensitive endpoints without protection**
- Do not create public endpoints for user metrics (`GET:/metrics/:email`)
- Do not allow unauthenticated access to workout data (`GET:/workouts/:email`)
- Do not permit plan modifications without proper authorization (`PUT:/plans/:id`, `DELETE:/plans/:id`)

## 💡 Quick Reference

**Need Help?**

- **Working on architecture topics**: [architecture.md](architecture.md)
- **Working on context topics**: [constraint_operational.md](constraint_operational.md)
- **Working on policies topics**: [policies.md](policies.md)
- **Working on rules topics**: [rules.md](rules.md)
- **Working on setup readme topics**: [setup/README.md](setup/README.md)
- **Working on standards topics**: [standards.md](standards.md)

*This instruction index references 18 context documents.*