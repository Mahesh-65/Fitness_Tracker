---
applyTo: '**'
---
# standards

## API Standards
### REST API Conventions

The Fitness Tracker application follows RESTful API design principles with consistent endpoint patterns:

#### Resource-Based URLs
- **Plans**: `/plans` (collection), `/plans/:id` (specific resource)
- **Metrics**: `/metrics` (collection), `/metrics/:email` (user-specific)
- **Workouts**: `/workouts/:email` (user-specific collection)
- **Users**: `/user` (current user context)

#### HTTP Method Usage
- `GET`: Retrieve resources (plans, metrics, workouts, user data)
- `POST`: Create new resources (registration, login, plans, metrics, workouts)
- `PUT`: Update existing resources (plan modifications)
- `DELETE`: Remove resources (plan deletion)

#### Authentication Requirements
All authenticated endpoints route through the `auth` handler:
- User management: `/login`, `/logout`, `/register`
- Data operations: `/plans/*`, `/metrics/*`, `/workouts/*`, `/log-workout`
- Testing: `/test`

#### Response Patterns
- Consistent error handling across all endpoints
- Standardized authentication flow for protected resources
- Email-based user identification for personalized data access

### Frontend API Integration

#### Form Initialization Endpoints
- `GET email-login`: Initialize email input component
- `GET password-login`: Initialize password input component  
- `GET role-login`: Initialize role selection component

#### User Context Management
- `GET user`: Load current authenticated user information
- `GET User-Agent`: Handle client identification requests

## Testing Standards
### Test Types Required

#### Unit Tests
- **Coverage**: Minimum 80% code coverage for all modules
- **Scope**: Individual functions, methods, and components
- **Framework**: Jest for JavaScript/TypeScript components
- **Location**: `__tests__/` directories alongside source files

#### Integration Tests
- **API Endpoints**: All authenticated endpoints must have integration tests
- **Database Operations**: Test database interactions with test database
- **Authentication Flow**: Complete login/logout/registration workflows
- **Cross-module**: Test interactions between different system components

#### End-to-End Tests
- **User Workflows**: Complete user journeys from registration to workout logging
- **Authentication**: Test protected routes and session management
- **Data Flow**: Verify data persistence across the full application stack

### Test Naming Conventions

#### Test Files
- Unit tests: `[component].test.js` or `[component].spec.js`
- Integration tests: `[feature].integration.test.js`
- E2E tests: `[workflow].e2e.test.js`

#### Test Descriptions
- Use descriptive `describe()` blocks for test suites
- Use `it()` statements that complete the sentence "it should..."
- Group related tests with nested `describe()` blocks

### Coverage Expectations

#### Minimum Requirements
- **Overall Coverage**: 80% minimum across all code
- **Critical Paths**: 95% coverage for authentication and data persistence
- **API Endpoints**: 100% coverage for all authenticated endpoints
- **Error Handling**: All error paths must be tested

#### Coverage Reporting
- Generate coverage reports with each test run
- Include coverage badges in README
- Fail CI/CD pipeline if coverage drops below thresholds

### Test Data Management

#### Test Database
- Use separate test database for integration tests
- Clean database state between test runs
- Use database transactions for test isolation

#### Mock Data
- Create reusable test fixtures for common data scenarios
- Mock external API calls and third-party services
- Use factory patterns for generating test data

### Continuous Integration

#### Test Execution
- Run all tests on every pull request
- Execute tests in parallel where possible
- Fail builds on test failures or coverage drops

#### Test Environment
- Maintain consistent test environment across all developers
- Use containerized testing for reproducible results
- Test against multiple Node.js versions if applicable

## API Standards
### REST API Design

#### Resource Endpoints

| Resource | Method | Endpoint | Description |
|----------|--------|----------|-------------|
| Plans | GET | `/plans/:trainer` | Retrieve plans for a specific trainer |
| Plans | POST | `/plans` | Create a new fitness plan |
| Plans | PUT | `/plans/:id` | Update an existing plan by ID |
| Plans | DELETE | `/plans/:id` | Delete a specific plan by ID |
| Metrics | GET | `/metrics/:email` | Retrieve metrics for a specific user |
| Metrics | POST | `/metrics` | Create new user metrics |
| Workouts | GET | `/workouts/:email` | Retrieve workouts for a specific user |
| Workouts | POST | `/log-workout` | Log a new workout entry |

#### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/register` | Register a new user account |
| POST | `/login` | Authenticate user login |
| POST | `/logout` | Log out current user |
| GET | `user` | Retrieve current user information |

### URL Conventions

`:email`, `/metrics`

### HTTP Methods

- **GET**: Retrieve resources (read-only operations)
- **POST**: Create new resources or perform actions
- **PUT**: Update existing resources
- **DELETE**: Remove resources

### Authentication Requirements

Most API endpoints require authentication and route through the auth handler, ensuring secure access to user data and operations. Only public endpoints like the root path (`/`) operate without authentication requirements.

### Development Endpoints

- **POST** `/test`: Test endpoint for development and debugging purposes
- **GET** `/`: Root application endpoint for health checks

## Engineering Standards
### Code Review Standards

#### Authentication Implementation
- **Mandatory Authentication**: All API endpoints must implement proper authentication mechanisms
- **Consistent Auth Patterns**: Follow established authentication patterns across all endpoints
- **Security Review**: Authentication logic requires mandatory security review before deployment

#### API Development Standards
- **Endpoint Security**: Ensure all endpoints route through appropriate authentication handlers
- **Error Handling**: Implement consistent error responses for authentication failures
- **Testing Requirements**: All authenticated endpoints must include authentication test cases

### Documentation Standards

#### API Documentation
- **Endpoint Documentation**: Document authentication requirements for each endpoint
- **Security Notes**: Include security considerations in API documentation
- **Example Requests**: Provide authenticated request examples

#### Code Documentation
- **Authentication Flow**: Document authentication mechanisms and token handling
- **Security Patterns**: Document reusable security patterns and implementations
- **Error Scenarios**: Document authentication error handling and recovery

### Development Standards

#### Security-First Development
- **Authentication by Default**: New endpoints must include authentication unless explicitly exempted
- **Token Management**: Follow established patterns for token creation, validation, and expiration
- **Access Control**: Implement proper authorization checks beyond authentication

#### Quality Assurance
- **Security Testing**: Mandatory security testing for all authentication-related code
- **Code Reviews**: Multi-reviewer approval required for authentication changes
- **Compliance Checks**: Regular audits of authentication implementation consistency

## Code Quality Standards
### Linting and Formatting

#### ESLint Configuration
- Use ESLint for JavaScript/TypeScript code analysis
- Configure rules for consistent code style and error prevention
- Enforce consistent indentation, semicolon usage, and variable naming
- Enable rules for detecting unused variables and imports

#### Prettier Integration
- Use Prettier for automatic code formatting
- Configure consistent formatting for JavaScript, TypeScript, JSON, and Markdown files
- Set up pre-commit hooks to ensure all code is formatted before commits
- Maintain consistent line length and bracket spacing

### Quality Metrics

#### Code Coverage
- Maintain minimum 80% test coverage for all modules
- Use Jest or similar testing framework for coverage reporting
- Generate coverage reports in CI/CD pipeline
- Exclude configuration files and build artifacts from coverage calculations

#### Static Analysis
- Run static analysis tools to detect potential security vulnerabilities
- Use tools like SonarQube or CodeClimate for code quality assessment
- Monitor cyclomatic complexity and maintain scores below 10 per function
- Track technical debt and prioritize refactoring efforts

### Pre-commit Hooks

#### Required Checks
- Lint all staged files before commit
- Run Prettier formatting on staged files
- Execute unit tests for modified modules
- Validate commit message format

#### Setup

### Continuous Integration

#### Quality Gates
- All linting checks must pass before merge
- Code coverage must not decrease below threshold
- No high-severity security vulnerabilities allowed
- All tests must pass in CI environment

#### Automated Checks
- Run ESLint and Prettier checks on every pull request
- Generate and publish code coverage reports
- Perform dependency vulnerability scanning
- Execute performance regression tests