# TaskFlow

TaskFlow is a small task manager app built with Flutter. You sign up with an email and password, and your tasks are saved in your own Firebase project (Cloud Firestore).

This guide is written for **Windows** and an **Android phone**. Follow the steps in order. It takes about 45–60 minutes the first time, mostly installing tools.

**Features**

- Email/password sign up, log in and log out, with clear error messages
- Create, view, edit and delete tasks (swipe left on a card, or use the Delete button on the edit screen)
- Mark tasks complete or incomplete
- Filter by status (All / Active / Completed) and priority (All / Low / Medium / High)
- Tasks sorted by due date (earliest first) and grouped into Overdue, Today, Tomorrow and Upcoming
- Live updates: the list refreshes as soon as Firestore changes

---

## Step 0: Unpack the project

Windows 10 and 11 can extract `.tar.gz` files themselves.

1. Create a short folder, for example `C:\dev`. Keep the path short and **without spaces**, because Android builds on Windows can fail when paths are long.
2. Move `taskflow.tar.gz` into `C:\dev`.
3. Open **Command Prompt** (press Start, type `cmd`, press Enter) and run:

```bat
cd C:\dev
tar -xzf taskflow.tar.gz
cd taskflow
```

You now have the project in `C:\dev\taskflow`.

> **Use Command Prompt (`cmd`) for every command in this guide.** PowerShell sometimes blocks the `npm` and `firebase` commands with "running scripts is disabled on this system". If you prefer PowerShell, first run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` and answer `Y`.

---

## Step 1: Install the tools (one time only)

Install these in this order. **After installing each one, close Command Prompt and open a new one**, because new programs are only found in a fresh window.

### 1.1 Git for Windows

Flutter needs it. Download it from https://git-scm.com/download/win and install with the default options.

### 1.2 Flutter SDK

1. Go to https://docs.flutter.dev/get-started/install/windows/mobile and download the latest **stable** Flutter zip.
2. Extract it to `C:\src\flutter`, so that the file `C:\src\flutter\bin\flutter.bat` exists. Don't put it in `C:\Program Files`.
3. Add Flutter to your PATH:
   1. Press Start, type **"environment variables"**, and open **Edit environment variables for your account**.
   2. Select **Path** and click **Edit → New**.
   3. Type `C:\src\flutter\bin`, then click **OK** and **OK**.
4. Open a **new** Command Prompt and check:

```bat
flutter --version
```

### 1.3 Android Studio

You need Android Studio for the Android SDK and Java, even though you'll run the app from the command line.

1. Download it from https://developer.android.com/studio and install with the default options.
2. Open it once and finish the setup wizard. It downloads the Android SDK.
3. In Android Studio, go to **More Actions → SDK Manager → SDK Tools** and tick:
   - **Android SDK Command-line Tools (latest)**
   - **Google USB Driver** (needed for Google Pixel phones; other brands are covered in Step 6)
4. Click **Apply**.
5. Back in Command Prompt, run:

```bat
flutter doctor --android-licenses
```

Press `y` for every question. Then run:

```bat
flutter doctor
```

The **Flutter** and **Android toolchain** lines should have a green tick. You can ignore Chrome, Visual Studio and Windows-related warnings, because they aren't needed for Android.

### 1.4 Node.js

The Firebase command-line tool needs it. Download the **LTS** installer from https://nodejs.org and install with the default options. Then open a new Command Prompt and check:

```bat
node --version
```

### 1.5 Firebase CLI and FlutterFire CLI

```bat
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

The second command prints a warning that `...\Pub\Cache\bin` is not on your PATH. Add it in the same way as Flutter in step 1.2:

1. Open **Edit environment variables for your account → Path → Edit → New**.
2. Paste this line exactly:

```
%LOCALAPPDATA%\Pub\Cache\bin
```

3. Click **OK** and **OK**, then open a **new** Command Prompt and check:

```bat
firebase --version
flutterfire --version
```

---

## Step 2: Create your Firebase project (in the browser)

1. Open https://console.firebase.google.com and sign in with a Google account.
2. Click **Create a project** (or **Add project**). Name it, for example `taskflow`. You can turn Google Analytics off. Click **Create**.
3. Turn on login:
   1. In the left menu, go to **Build → Authentication → Get started**.
   2. Open the **Sign-in method** tab, click **Email/Password**, switch on the first toggle, and click **Save**.
4. Create the database:
   1. In the left menu, go to **Build → Firestore Database → Create database**.
   2. Pick a location near you and click **Next**.
   3. Choose **Start in production mode** and click **Create**.
5. Publish the security rules, so that each user can only see their own tasks:
   1. In Firestore, open the **Rules** tab.
   2. Delete everything there.
   3. Open `C:\dev\taskflow\firestore.rules` in Notepad, copy all of it, and paste it into the Rules editor.
   4. Click **Publish**.

The rules should look like this:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid}/tasks/{taskId} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

---

## Step 3: Connect the app to your Firebase project

In Command Prompt, run:

```bat
cd C:\dev\taskflow
firebase login
```

A browser window opens. Log in with the **same Google account** you used in Step 2 and allow access.

Then run:

```bat
flutterfire configure --platforms=android
```

- Use the arrow keys to choose the project you created and press Enter.
- If it asks for an Android package name, use `com.example.taskflow`.

This creates two files. You don't type any keys by hand:

| File | What it is |
| --- | --- |
| `lib\firebase_options.dart` | Your Firebase settings. This replaces the placeholder that ships with the project. |
| `android\app\google-services.json` | Android Firebase config |

> Until you finish this step, the app opens and stops straight away with "Firebase is not configured". That message comes from the placeholder `lib\firebase_options.dart` file.

---

## Step 4: Download the app's packages

```bat
flutter pub get
```

---

## Step 5: Prepare your Android phone

1. **Turn on Developer options:**
   1. On the phone, open **Settings → About phone**.
   2. Tap **Build number** 7 times. On Xiaomi/Redmi phones, tap **MIUI version**. On some Samsung phones it's under **Software information**.
   3. You'll see "You are now a developer".
2. **Turn on USB debugging:** open **Settings → System → Developer options** and switch on **USB debugging**. On Xiaomi phones, also switch on **Install via USB**.
3. Connect the phone to the laptop with a USB cable that supports **data**. Some cables only charge.
4. If the phone asks which USB mode to use, choose **File transfer**.
5. The phone shows **"Allow USB debugging?"**. Tick **Always allow from this computer** and tap **Allow**.
6. Check that the laptop sees the phone:

```bat
flutter devices
```

Your phone should appear in the list.

---

## Step 6: Run the app on the phone

```bat
flutter run
```

The first run takes **5–10 minutes**, because Gradle downloads a lot. Later runs are much faster.

When it finishes, the app installs and opens on the phone. Leave the window open while you use the app:

- Press `r` to reload after code changes.
- Press `q` to quit.

The app stays installed on the phone, so you can open it again later without the laptop.

**Alternative: build an APK file and install it by hand**

```bat
flutter build apk
```

The file is created at `build\app\outputs\flutter-apk\app-release.apk`. Send it to the phone (for example over WhatsApp or USB) and open it there. Android asks you to allow installing from that source.

---

## Step 7: Try it out

1. On the onboarding screen, tap the arrow, then **sign up** with any email (it doesn't need to be real) and a password of 6 or more characters.
2. Tap **+** to add a task with a title, due date and priority.
3. Tap a task to edit it, tap its circle to mark it done, and swipe left to delete it.
4. Use the **Status** and **Priority** chips to filter the list.
5. Log out with the icon in the top-right corner, then log back in. Your tasks are still there.

You can see the saved users under **Authentication → Users** in the Firebase console, and the tasks under **Firestore Database → Data**.

---

## Running the tests

```bat
flutter test
```

---

## Common problems

| Problem | Fix |
| --- | --- |
| `'flutter' is not recognized...` | Flutter's `bin` folder isn't on PATH (step 1.2). Open a **new** Command Prompt after changing PATH. |
| `'flutterfire' is not recognized...` | Add `%LOCALAPPDATA%\Pub\Cache\bin` to PATH (step 1.5) and open a new Command Prompt. |
| `running scripts is disabled on this system` | You're in PowerShell. Use **Command Prompt**, or run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`. |
| App closes at start, or "Firebase is not configured" / "No Firebase App has been created" | Step 3 wasn't done. Run `flutterfire configure --platforms=android`, then `flutter run` again. |
| `PERMISSION_DENIED` or tasks don't load | The Firestore rules weren't published (Step 2.5). |
| Sign-up fails with "Something went wrong" | Email/Password isn't enabled in Firebase Authentication (Step 2.3). |
| "No internet connection." | The phone has no internet. Turn on Wi-Fi or mobile data. |
| Phone not shown in `flutter devices` | Check that USB debugging is on, use a data cable, and tap **Allow** on the phone. Try `adb kill-server` and then `flutter devices`. For Samsung/Xiaomi/others, install the brand's USB driver (search "<brand> USB driver"). |
| `Android license status unknown` | Run `flutter doctor --android-licenses` and accept everything. |
| Build fails with long-path or "filename too long" errors | Move the project to a short path like `C:\dev\taskflow`. |
| Gradle build fails on the first run | Check your internet connection and run `flutter clean`, then `flutter run` again. |

---

## How the code is organised (for developers)

The app uses **MVVM with GetX**, and data flows one way:

- **Model** (`lib/models`): `TaskModel` is a plain Dart class with `fromMap` / `toMap`.
- **Service** (`lib/services`): `AuthService` and `TaskService` are thin wrappers. Firebase calls only happen here.
- **ViewModel** (`lib/viewmodels`): `AuthViewModel` and `TaskViewModel` extend `GetxController`. They hold reactive state (`.obs`), validate input, call services and handle navigation.
- **View** (`lib/views`): screens and widgets read state with `Obx(() => ...)` and call ViewModel methods. Views never import Firebase.

```
lib/
├── main.dart                 # Firebase init, GetX DI, GetMaterialApp
├── firebase_options.dart     # created by flutterfire configure (placeholder until then)
├── models/                   # TaskModel + Priority enum
├── services/                 # AuthService, TaskService
├── viewmodels/               # AuthViewModel, TaskViewModel
├── views/                    # screens
│   └── widgets/              # reusable widgets (task card, filter bar, ...)
├── routes/                   # route names + GetPage list with bindings
└── utils/                    # colours, theme, validators, date helpers
test/                         # unit tests
firestore.rules               # Firestore security rules
```

## Assumptions

- Filtering and sorting happen on the client, over the already-loaded list. This means no composite Firestore indexes are needed.
- There is one onboarding screen instead of a carousel.
- There is no social login (Google, Facebook or Apple).
- Tapping a task opens it in the edit form, which also shows the full description. There is no separate detail screen.
- Tasks are grouped by due date only, so a completed task with a past date still appears under "Overdue". Its date is grey rather than red.
- Tasks with the same due date are ordered by priority, highest first.
- The due date picker starts at today. When you edit an older task, its original date can still be kept.
- The task list header uses the primary colour. Primary light is used for the onboarding circle and disabled buttons.
- The Log in and Sign up screens share one `AuthViewModel`, and the fields are cleared when you switch between them.
- Android `minSdk` is 24 instead of 23: Flutter 3.38 requires at least 24 and automatically raises lower values. Firebase only needs 23.
- Firebase credential files (`lib/firebase_options.dart`, `android/app/google-services.json`) are git-ignored, so each person connects their own Firebase project.
