# Flutter SaaS Web App — Production-Grade Implementation Prompt

## Objective

Build the initial Flutter application for my SaaS product using a **production-grade, scalable, maintainable, and industry-standard Flutter architecture**.

The product is a SaaS platform for organizations that need to manage multiple branches from a centralized organization panel.

The application should initially contain **two routes/pages**:

1. `/` — Public SaaS landing/showcase page
2. `/login` — Authentication/login page

Use **GoRouter** for navigation and structure the project so it can scale significantly as more modules are added later.

---

# Product Context

The SaaS product allows an organization to manage multiple branches.

### Organization-level functionality

An organization will eventually be able to:

* Create and manage branches
* View all branches
* Manage branch-level information
* Monitor branch activity
* Manage organization-level settings
* Manage users/staff across branches
* Access centralized organization analytics

### Branch-level functionality

Each branch will eventually have its own management panel where it can manage things such as:

* Students
* Staff
* Courses
* Classes
* Attendance
* Fees
* Academic information
* Branch settings
* Reports
* Other branch-specific operations

Do **not** implement these modules yet.

For now, only create the foundation and the two requested pages while designing the architecture so these modules can be added cleanly later.

---

# Required Routes

Use **GoRouter**.

```text
/
└── Landing / Product Showcase

/login
└── Login
```

The routing architecture should be designed so that authenticated application routes can later be added without restructuring the entire application.

For example, the architecture should be ready for future routes such as:

```text
/organization
/organization/branches
/organization/settings

/branch
/branch/students
/branch/staff
/branch/courses
/branch/settings
```

Do not implement these routes now.

---

# Page 1 — `/`

Create a professional SaaS landing/showcase page.

The purpose of this page is to clearly communicate what the product does and make it look like a real modern SaaS product rather than a basic Flutter demo.

## Landing page should include

### Hero section

Clearly communicate:

* What the product is
* Who it is for
* The primary value proposition

Example messaging direction:

> Manage your entire organization and every branch from one powerful platform.

Include:

* Strong headline
* Supporting description
* Primary CTA
* Secondary CTA if appropriate

Primary CTA:

```text
Get Started
```

Secondary CTA:

```text
Sign In
```

The CTA should navigate using GoRouter.

`Get Started` can temporarily navigate to `/login` unless a better route is required by the architecture.

`Sign In` must navigate to:

```text
/login
```

---

## Product showcase

Show the core concept visually:

```text
Organization
      │
      ├── Branch 1
      │     ├── Students
      │     ├── Staff
      │     ├── Courses
      │     └── Management
      │
      ├── Branch 2
      │     ├── Students
      │     ├── Staff
      │     ├── Courses
      │     └── Management
      │
      └── Branch 3
            ├── Students
            ├── Staff
            ├── Courses
            └── Management
```

Present this concept in a visually polished SaaS-oriented way.

Avoid making the landing page look like a generic Flutter template.

---

## Features section

Create a clean feature section communicating concepts such as:

* Multi-branch management
* Centralized organization control
* Branch-level management
* Student management
* Staff management
* Course management
* Analytics and reporting
* Secure access

These are showcase/marketing elements only.

Do not implement actual functionality for these modules.

---

## Architecture/value section

Include a section explaining the platform concept:

### One organization. Multiple branches. One platform.

Explain that organizations can centrally manage their branches while each branch can independently manage its daily operations.

---

## Final CTA

Add a professional CTA near the bottom of the page encouraging users to get started.

---

# Page 2 — `/login`

Create a professional login screen.

The screen should include:

* Product branding/logo area
* Welcome heading
* Email field
* Password field
* Show/hide password functionality
* Remember me
* Forgot password
* Login button
* Appropriate validation/error states

Authentication itself does not need to be connected to a backend yet.

However, structure the code so that authentication can later be connected to an API without rewriting the UI.

Create an abstraction such as an authentication repository/service rather than putting API logic directly inside widgets.

---

# Theme Requirements

The application **must fully support both light mode and dark mode**.

The UI must automatically follow the system theme.

### Light mode

When the operating system is using light mode:

```text
App → Light Theme
```

### Dark mode

When the operating system is using dark mode:

```text
App → Dark Theme
```

Use:

```dart
ThemeMode.system
```

Do not hardcode the application to light or dark mode.

Create proper centralized theme definitions:

```text
lightTheme
darkTheme
```

Use Material 3.

Avoid scattering colors throughout widgets.

Instead, define reusable design tokens/theme configuration for:

* Colors
* Typography
* Spacing
* Border radius
* Shadows
* Component styling

The UI should look intentional in both themes.

Do not simply invert colors for dark mode.

Dark mode should be properly designed with appropriate surfaces, contrast, borders, typography, and elevation.

---

# Architecture

Use a **production-grade feature-oriented Flutter architecture**.

Do not put everything inside:

```text
lib/
  screens/
  widgets/
```

with hundreds of unrelated files.

Use clear separation between:

* Presentation
* Domain/business logic
* Data
* Core/shared infrastructure

A recommended structure is:

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── app_colors.dart
│       ├── app_typography.dart
│       ├── app_spacing.dart
│       └── app_radius.dart
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── utils/
│   └── network/
│
├── features/
│   ├── landing/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── landing_screen.dart
│   │       └── widgets/
│   │           ├── hero_section.dart
│   │           ├── feature_section.dart
│   │           ├── product_showcase.dart
│   │           ├── organization_structure.dart
│   │           └── final_cta_section.dart
│   │
│   └── authentication/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── screens/
│           │   └── login_screen.dart
│           ├── widgets/
│           │   ├── login_form.dart
│           │   ├── email_field.dart
│           │   ├── password_field.dart
│           │   └── auth_header.dart
│           └── controllers/
│
├── shared/
│   ├── widgets/
│   ├── buttons/
│   ├── inputs/
│   ├── layouts/
│   └── responsive/
│
└── main.dart
```

You may improve this structure if there is a better industry-standard approach.

The important requirement is **clear separation of responsibility and scalability**.

---

# Screen vs Widget Responsibility

Follow this rule strictly:

### Screens

Screens should primarily:

* Compose the page
* Handle page-level layout
* Connect presentation logic
* Coordinate widgets

Screens should NOT contain hundreds of lines of UI implementation.

### Widgets

Break meaningful UI sections into dedicated widgets.

For example:

```text
HeroSection
FeatureSection
ProductShowcase
OrganizationStructure
FinalCtaSection
```

Avoid both extremes:

### Bad

One 800-line `LandingScreen`.

### Also bad

Creating dozens of meaningless one-line widgets.

Only extract components when they represent a meaningful reusable or logically isolated UI section.

---

# Responsive Design

The application must work well across:

* Desktop
* Tablet
* Mobile

The landing page should not simply overflow or become unusable on smaller screens.

Use responsive layouts appropriately.

For example:

```text
Desktop
Hero:
[Text] [Product Visualization]

Mobile
[Text]
[Product Visualization]
```

Feature grids should adapt based on available width.

Login should also be responsive.

The design should feel intentionally responsive rather than simply shrinking desktop components.

---

# UI/UX Requirements

The visual design should feel like a modern premium SaaS product.

Prioritize:

* Clean typography
* Strong visual hierarchy
* Generous whitespace
* Consistent spacing
* Subtle borders
* Subtle shadows
* Professional cards
* Modern buttons
* Proper hover states where applicable
* Smooth transitions where useful
* Consistent border radius
* Strong alignment
* Excellent responsive behavior

Avoid:

* Generic Flutter demo styling
* Excessive gradients
* Excessive animations
* Huge rounded containers everywhere
* Random colors
* Inconsistent spacing
* Overly verbose UI
* Unnecessary visual clutter
* Hardcoded dimensions that break responsiveness

The design should look appropriate for a real B2B SaaS product.

---

# Navigation

Use GoRouter properly.

Do not navigate using ad-hoc `Navigator.push` calls for application routing.

Create centralized route definitions.

For example:

```dart
GoRoute(
  path: '/',
  name: RouteNames.landing,
  builder: ...
),
GoRoute(
  path: '/login',
  name: RouteNames.login,
  builder: ...
),
```

Prefer named navigation where appropriate.

Prepare the router for future authentication guards.

For example, the architecture should make it straightforward to later implement:

```text
Unauthenticated user
        ↓
/login

Authenticated user
        ↓
/organization or /branch
```

Do not implement authentication guards yet unless necessary for the current two routes.

---

# State Management

Do not introduce a heavy state-management architecture unless it is actually required.

Keep the current implementation simple but scalable.

If state management is needed, use a clean architecture that can later support:

* Authentication state
* Organization state
* Branch state
* User state

Do not put application/business state directly into UI widgets.

---

# Authentication Architecture

Even though the login API is not being implemented yet, prepare the architecture for it.

A future API should be able to look conceptually like:

```text
LoginScreen
    ↓
AuthController
    ↓
LoginUseCase
    ↓
AuthRepository
    ↓
AuthRemoteDataSource
    ↓
API
```

Do not directly call HTTP APIs from `LoginScreen`.

For now, use a mock/local implementation where necessary.

---

# Code Quality

Follow professional Dart/Flutter coding standards.

Requirements:

* Null safety
* Strong typing
* `const` constructors wherever possible
* Immutable widgets where appropriate
* Meaningful naming
* Small focused classes
* No unnecessary duplication
* No magic numbers
* No magic colors
* No business logic inside presentation widgets
* No unnecessary global state
* No dead code
* No unused imports
* No placeholder architecture that serves no purpose

Use linting and formatting standards.

The project should pass:

```bash
flutter analyze
```

and should be formatted using:

```bash
dart format .
```

Avoid suppressing analyzer warnings unless there is a legitimate reason.

---

# Accessibility

Build the UI with accessibility in mind.

Use:

* Proper semantic labels where required
* Sufficient contrast
* Keyboard-friendly interactions on web/desktop
* Reasonable touch target sizes
* Meaningful button labels
* Proper form field labels

Do not rely solely on color to communicate state.

---

# Performance

Avoid unnecessary rebuilds.

Use:

* `const` widgets where possible
* Efficient lists/grids
* Lazy construction where appropriate
* Avoid unnecessary expensive operations during build

Do not prematurely optimize.

Focus on clean and predictable rendering.

---

# Dependencies

Only introduce dependencies when they provide meaningful value.

At minimum, use:

```yaml
go_router:
```

Do not add large numbers of packages simply for convenience.

Before adding a package, consider whether Flutter/Dart already provides a clean solution.

---

# Error and Loading States

The login UI should have proper visual states for:

```text
Idle
Loading
Success
Error
```

Even though the API is not implemented, structure the presentation layer so these states can easily be connected later.

For example:

```text
Login
   ↓
Loading
   ↓
Success → Navigate
   OR
Error → Show error
```

---

# Deliverables

Implement the complete initial Flutter application.

The final implementation must include:

### Routing

```text
/
 /login
```

### Landing page

* Hero
* Product showcase
* Organization → branches concept
* Features
* SaaS value proposition
* CTA

### Login page

* Professional login UI
* Email validation
* Password validation
* Password visibility toggle
* Remember me
* Forgot password UI
* Loading state
* Error state
* Login CTA

### Theme

* System theme detection
* Light theme
* Dark theme
* Material 3
* Centralized theme tokens

### Architecture

* Feature-based structure
* Presentation separation
* Domain separation
* Data separation
* Reusable shared components
* Scalable routing

### Quality

* Responsive
* Accessible
* Clean
* Maintainable
* Production-grade
* `flutter analyze` passes
* Proper formatting
* No unnecessary technical debt

---

# Important Implementation Rules

1. **Do not create a monolithic `main.dart`.**
2. **Do not put all UI into one screen file.**
3. **Do not put API/business logic inside widgets.**
4. **Do not hardcode colors throughout the UI.**
5. **Do not hardcode light/dark mode.**
6. **Use `ThemeMode.system`.**
7. **Use GoRouter for application navigation.**
8. **Keep authentication architecture ready for a real backend.**
9. **Keep the architecture scalable for future organization and branch modules.**
10. **Use feature-based folders.**
11. **Keep screens responsible for composition and widgets responsible for isolated UI sections.**
12. **Make the design responsive from the beginning.**
13. **Prefer simple, maintainable solutions over unnecessary abstractions.**
14. **Do not implement future modules yet. Only establish the architecture required to support them.**
15. **The final result should look like a real production SaaS application, not a tutorial/demo Flutter project.**

Before finishing, review the entire implementation as a senior Flutter engineer and refactor anything that violates separation of concerns, scalability, readability, responsiveness, or Flutter best practices.
