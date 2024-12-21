# Simplex Chapter
# Technical Documentation for Flutter Application

## Architecture Document

### Overview of the App's Architecture

The app follows a layered architecture comprising the following key components:

#### 1. **Frontend (Flutter)**

- **User Interface**:
  - The UI is built with Flutter widgets and follows Material Design principles.
  - Major pages include:
    - `HomePage`: Dashboard showing tasks, events, and user-specific details.
    - `TasksPage`: Manages task overviews and interactions.
    - `ChatsPage`: Handles chat-based communication within chapters.
    - `SettingsPage`: Placeholder for customizable settings like dark mode.
    - `ProfilePage`: Displays user account options and logout functionality.
- **Widget Structure**:
  - **Stateless Widgets**:
    - `LoginPage`: Static UI for login.
    - `CreateAccountWidget`: Static UI for account creation.
  - **Stateful Widgets**:
    - `ShowTasks`: Dynamically updates tasks using Firestore streams.
    - `TaskLandingPageWidget`: Handles task-specific actions and displays task details.
- **Navigation**:
  - Navigation is implemented via `PageView` and a Bottom Navigation Bar.
  - Key methods:
    - `onPageChanged`: Updates the UI when the user switches between tabs.
    - `navigateToPage(index)`: Programmatically navigates to specific pages.
- **Theming**:
  - Managed centrally with `FlutterFlowTheme`, supporting:
    - Light mode.
    - Dark mode.
  - Key methods:
    - `loadTheme()`: Loads the current theme from shared preferences.
    - `saveTheme()`: Saves user-selected themes.

#### 2. **Backend**

- **Data Storage**:
  - Firebase Firestore:
    - Collections:
      - `users`: User profiles and preferences.
      - `chapters`: Details of chapters, including members and announcements.
      - `tasks`: Task-related data like submissions and due dates.
      - `events`: Event schedules and attendees.
    - Documents follow well-defined schemas for consistency.
    - Key queries:
      - `getDocumentById(collection, id)`: Retrieves a document from Firestore.
      - `queryCollection(collection, filters)`: Queries Firestore with specific conditions.
  - Firebase Storage:
    - Handles file uploads and downloads for attachments in tasks and announcements.
    - Key methods:
      - `uploadFile(path, file)`: Uploads a file to a specified path.
      - `downloadFile(path)`: Downloads a file from Firebase Storage.
- **Authentication**:
  - Firebase Authentication supports:
    - Email and password.
    - OAuth (Google, Apple).
    - Key methods:
      - `signInWithEmailAndPassword(email, password)`: Logs in a user.
      - `createUserWithEmailAndPassword(email, password)`: Creates a new user account.
      - `signOut()`: Logs out the user.
- **Cloud Functions**:
  - Used for:
    - Sending push notifications.
    - Validating join codes during chapter onboarding.
    - Key triggers:
      - `onAnnouncementCreate`: Sends notifications when a new announcement is created.

#### 3. **State Management**

- Managed through `AppInfo`, a singleton class.
  - Holds global state variables like:
    - `currentUser`: Stores the currently logged-in user.
    - `currentChapter`: Tracks the chapter selected by the user.
    - `isExec`: Boolean flag indicating if the user has executive privileges.
  - Key methods:
    - `loadUserData(uid)`: Loads user data from Firestore.
    - `updateChapter(chapterId)`: Updates the current chapter and fetches related data.
- **Advantages**:
  - Simplifies data flow and sharing across widgets.
  - Minimizes redundancy in accessing backend services.

### Diagram of App Structure

Below is an updated detailed diagram of the app’s structure:

```plaintext
Root Widget (MyApp)
 ├── Navigation (Bottom Navigation Bar)
 |   ├── Home Page
 |   |   └── Widgets:
 |   |       ├── ShowTasks
 |   |       └── ShowEvents
 |   ├── Tasks Page
 |   |   └── Widgets:
 |   |       ├── ShowAllTasksWidget
 |   |       └── TaskLandingPageWidget
 |   ├── Chats Page
 |   |   └── Widgets:
 |   |       ├── ChatroomPage
 |   |       └── JoinChats
 |   ├── Settings Page
 |   └── Profile Page
 ├── Auth Widgets
 |   ├── Login Page
 |   ├── Create Account Page
 |   └── Forgot Password Page
 ├── Feature Widgets
 |   ├── Task Management:
 |   |   └── TaskLandingPageWidget
 |   ├── Event Management:
 |   |   └── EventLandingPage
 |   ├── Chapter Management:
 |   |   └── ChapterSelectWidget
 └── Backend Models
     ├── UserModel
     ├── TaskModel
     ├── EventModel
     ├── AnnouncementModel
     └── ChapterModel
```

## API Documentation

### Integration Points Between the Flutter App and Backend Services

The app interacts with Firebase services at multiple integration points:

#### 1. **Authentication**

- **Google Sign-In**:
  - Method: `signInWithGoogle` in `AuthService`.
  - Description: Initiates OAuth flow, retrieves user credentials, and creates or updates Firestore user documents.
- **Apple Sign-In**:
  - Method: `signInWithApple` in `AuthService`.
  - Description: Similar to Google Sign-In but uses Apple’s OAuth services.
- **Email/Password**:
  - Method: `signInWithEmailAndPassword` in `AuthService`.
  - Description: Authenticates users with email and password credentials.

#### 2. **Data Retrieval and Updates**

- **Firestore**:
  - Users:
    - Path: `/users/{userId}`.
    - Description: Fetch user profile, current chapter, and task progress.
    - Methods:
      - `getUserById(userId)`: Fetches user data.
      - `writeUser(data)`: Creates or updates user data.
  - Chapters:
    - Path: `/chapters/{chapterId}`.
    - Description: Manage chapter data, including members, announcements, and events.
    - Methods:
      - `getChapterById(chapterId)`: Fetches chapter details.
      - `joinChapter(chapterId)`: Adds the current user to a chapter.
  - Tasks:
    - Path: `/chapters/{chapterId}/tasks/{taskId}`.
    - Description: CRUD operations for task details, user submissions, and statuses.
    - Methods:
      - `createTask(data)`: Creates a new task.
      - `getTaskById(taskId)`: Fetches details of a specific task.
      - `completeTask(taskId)`: Marks a task as completed.
  - Events:
    - Path: `/chapters/{chapterId}/events/{eventId}`.
    - Description: Store and retrieve event schedules and attendee data.
    - Methods:
      - `createEvent(data)`: Creates a new event.
      - `getEventById(eventId)`: Retrieves event details.

#### 3. **Push Notifications**

- Firebase Cloud Messaging:
  - Used by `AnnouncementModel` to broadcast announcements to subscribed users.
  - Notifications are triggered via Firebase Cloud Functions when new announcements are created.
  - Key Methods:
    - `sendNotification(title, body, tokens)`: Dispatches notifications to specified users.

#### 4. **Real-Time Updates**

- **StreamBuilder Widgets**:
  - Used in `ShowTasks` and `ShowAllTasksWidget` to render real-time updates from Firestore.
  - Methods:
    - `snapshots()`: Listens to Firestore changes.
    - `onDataChange()`: Updates the UI dynamically based on new data.

#### 5. **Error Handling**

- Toasts (`toast.dart`) are used to provide immediate feedback for backend errors or successful operations.
- Key Method:
  - `Toasts.toast(message, isError)`: Displays a toast notification with appropriate styling.

This enhanced detail ensures that developers understand the app’s architecture, backend integration, and data flow comprehensively.
