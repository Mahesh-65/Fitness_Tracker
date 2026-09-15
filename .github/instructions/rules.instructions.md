---
applyTo: '**'
---
# rules

## Naming Conventions
### API Endpoints

- Use lowercase with hyphens for multi-word endpoints: `/log-workout`
- Use resource-based naming: `/plans`, `/metrics`, `/metrics/:email`
- Use descriptive parameter names: `:trainer`

### HTTP Methods

- `GET` for retrieving data: `GET /workouts/:email`
- `POST` for creating resources: `POST /plans`, `POST /register`
- `PUT` for updating resources: `PUT /plans/:id`
- `DELETE` for removing resources: `DELETE /plans/:id`

### Route Parameters

### Authentication Endpoints

- Use clear, action-based names:
  - `/login` for authentication
  - `/logout` for session termination
  - `/register` for user registration

### Resource Collections

`/metrics`, `/workouts`
- Maintain consistency across related endpoints

## Architecture Rules
### Layer Boundaries

#### Authentication Layer
- **Rule**: All API endpoints MUST route through the authentication service
- **Rationale**: Centralized security control and consistent access management
- **Enforcement**: Authentication service acts as gateway for all backend operations

#### Frontend-Backend Separation
- **Rule**: Frontend classes (FitnessApp, Dashboard) MUST NOT directly access backend services
- **Rationale**: Maintains clear separation of concerns and enables independent scaling
- **Implementation**: All backend communication flows through defined API endpoints

### Import Rules

#### Service Dependencies
- **Rule**: Application service MUST be imported before authentication service initialization
- **Rationale**: Core functionality must be available before security layer activation
- **Pattern**: Service-oriented architecture with dependency injection

#### Frontend Class Structure
- **Rule**: Dashboard class MUST be instantiated after FitnessApp initialization
- **Rationale**: Main application context required before UI component creation
- **Implementation**: Method-based initialization pattern for frontend components

### Forbidden Patterns

#### Direct Database Access
- **Forbidden**: Frontend classes directly accessing data persistence layer
- **Alternative**: Use API endpoints routed through authentication service
- **Reason**: Violates security boundaries and architectural separation

#### Bypass Authentication
- **Forbidden**: Direct service calls that skip authentication routing
- **Alternative**: All requests must flow through authentication service gateway
- **Reason**: Compromises security model and access control consistency

#### Cross-Layer Dependencies
- **Forbidden**: Backend services importing frontend class dependencies
- **Alternative**: Use event-driven communication or API contracts
- **Reason**: Creates circular dependencies and deployment coupling

## Security Rules
### Authentication Rules

- **RULE-SEC-001**: All API endpoints MUST route through the authentication handler
- **RULE-SEC-002**: Login and registration endpoints are the ONLY exceptions to authentication requirements
- **RULE-SEC-003**: Implement proper session timeout and logout mechanisms

### Authorization Rules

- **RULE-SEC-004**: Users can ONLY access their own workout data and metrics
- **RULE-SEC-005**: Trainers can ONLY access plans they have created
- **RULE-SEC-006**: Email-based filtering MUST be enforced on all user-specific endpoints

### Input Validation Rules

### Secret Management Rules

## Async & Concurrency
### Required Async Patterns

service communications MUST use async/await patterns
- **File I/O**: File operations including logging

### Forbidden Sync Patterns

### Concurrency Guidelines

### Performance Considerations

## Error Handling
### Required Patterns

#### Authentication Error Handling
- **MUST** implement proper authentication error responses for protected endpoints
- **MUST** return appropriate HTTP status codes (401 for unauthorized, 403 for forbidden)
- **MUST** handle authentication failures gracefully without exposing sensitive information

#### API Error Response Format
- **MUST** return consistent error response structure across all endpoints
- **MUST** include meaningful error messages for client debugging
- **MUST** log errors appropriately for server-side debugging

#### Database Error Handling
- **MUST** handle database connection failures
- **MUST** implement proper transaction rollback on errors
- **MUST** sanitize database error messages before returning to client

#### Input Validation Errors
- **MUST** validate all input parameters before processing
- **MUST** return 400 Bad Request for invalid input with descriptive messages
- **MUST** handle malformed JSON requests gracefully

### Forbidden Patterns

#### Security Anti-Patterns
- **FORBIDDEN** to expose internal error details in production responses
- **FORBIDDEN** to return stack traces to client applications
- **FORBIDDEN** to log sensitive information (passwords, tokens) in error messages

#### Error Propagation
- **FORBIDDEN** to silently ignore errors without proper logging
- **FORBIDDEN** to use generic "Internal Server Error" messages without context
- **FORBIDDEN** to expose database schema information in error responses

#### Authentication Bypass
- **FORBIDDEN** to skip authentication checks on error conditions
- **FORBIDDEN** to return different error messages that could reveal user existence
- **FORBIDDEN** to cache authentication errors that could lead to security vulnerabilities

## Database Access
### ORM Usage

- **Primary Access Method**: Use ORM for all standard database operations to maintain type safety and prevent SQL injection
- **Model Definitions**: Define clear model classes for all entities (users, workouts, plans, metrics)
- **Relationship Mapping**: Utilize ORM relationship definitions for foreign key associations

### Raw SQL Rules

### Migration Conventions

### Connection Management

## Testing Standards
### Test File Organization

#### Directory Structure

```
src/
├── components/
│   ├── Auth/
│   │   ├── auth.js
│   │   └── __tests__/
│   │       └── auth.test.js
│   └── Metrics/
│       ├── metrics.js
│       └── __tests__/
│           └── metrics.test.js
└── __tests__/
    ├── integration/
    └── e2e/
```

#### Test File Naming
- **Unit Tests**: `[module-name].test.js`
- **Integration Tests**: `[feature-name].integration.test.js`
- **E2E Tests**: `[user-workflow].e2e.test.js`
- **Test Utilities**: `test-utils.js`, `fixtures.js`, `mocks.js`

### Test Function Naming

#### Describe Blocks
- Use the component/module name: `describe('AuthHandler', () => {})`
- For methods: `describe('validateToken()', () => {})`
- For features: `describe('User Registration Flow', () => {})`

#### Test Cases
- Start with "should": `it('should return 401 for invalid credentials', () => {})`
- Be specific: `it('should create workout plan with valid trainer ID', () => {})`
- Include edge cases: `it('should handle empty email parameter gracefully', () => {})`

### Authentication Testing Requirements

#### Required Test Scenarios
Based on the authentication-heavy API structure:

```javascript
describe('Protected Endpoints', () => {
  it('should require authentication for GET /metrics/:email', () => {});
  it('should require authentication for POST /plans', () => {});
  it('should require authentication for DELETE /plans/:id', () => {});
  it('should require authentication for POST /log-workout', () => {});
});
```

#### Authentication Flow Tests
- Valid login with correct credentials
- Invalid login attempts
- Token expiration handling
- Logout functionality
- Registration with duplicate emails
- Registration with invalid data

### Coverage Rules

#### Mandatory Coverage
- **Authentication handlers**: 100% coverage required
- **API endpoints**: All authenticated routes must be tested
- **Database operations**: All CRUD operations must be covered
- **Error handling**: All catch blocks and error responses

#### Coverage Thresholds

### Test Data Standards

#### Mock Data Naming
- Use descriptive names: `mockValidUser`, `mockExpiredToken`, `mockWorkoutPlan`
- Group by feature: `authMocks.js`, `workoutMocks.js`, `metricsMocks.js`
- Include edge cases: `mockUserWithLongEmail`, `mockEmptyWorkoutPlan`

#### Test Database Rules
- Use `test_` prefix for test database names
- Clean state between test suites
- Use transactions for test isolation
- Never use production data in tests

### Test Execution Standards

#### Pre-commit Requirements
- All tests must pass before commit
- Coverage thresholds must be met
- No test files should be skipped or disabled

#### CI/CD Integration
- Run tests on all pull requests
- Block merges on test failures
- Generate and publish coverage reports
- Test against multiple environments when applicable

## Anti-Patterns (Never Do)
### Authentication Anti-Patterns

❌ **Never expose sensitive endpoints without protection**
- Do not create public endpoints for user metrics (`GET:/metrics/:email`)
- Do not allow unauthenticated access to workout data (`GET:/workouts/:email`)
- Do not permit plan modifications without proper authorization (`PUT:/plans/:id`, `DELETE:/plans/:id`)

### API Design Anti-Patterns