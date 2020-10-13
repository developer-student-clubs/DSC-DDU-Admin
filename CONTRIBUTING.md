# Contributing

If you want to add a new feature or fix any issues, be sure to follow this guideline.

Please note we have a code of conduct, please follow it in all your interactions with the project.

## Important Notes

1. Before contributing to an issue, make sure that no one is assigned or has taken that issue. If no one is and you would like to work on the issue, please comment on the issue to let others know that someone is working on the issue.
2. Before creating a pull request, it is **important** that you make sure your branch and repository are up to date with this one. Some conflicts can be resolved, but many are hard to resolve. **Add the upstream** branch and always keep your branch up to date.

# Contents

  * [Get Started](#get-started)
  * [Create Pull Request](#create-pull-request)
  * [Code of Conduct](#code-of-conduct)

## Get Started

1. Fork this repo
2. Clone the forked repo
   ```
   git clone url-to-cloned-app
   ```
3. Go to the directory of cloned repo
   ```
   cd DSC-DDU-Admin
   ```
4. Get packages
   ```
   flutter pub get
   ```
5. Create a Firebase project

   1. Make a Firebase account if you don't already have one.
   2. Go to your [Firebase Console](https://console.firebase.google.com/u/0/)
   3. Select *Add Project*
   4. Give your project a name and follow the steps to create a project in your account.
   5. Go to your project dashboard
   6. Add android App
      1. Android Package Name: `com.dscddu.dsc_admin`
      2. Download `google-services.json`
      3. Put this file in `DSC-DDU-Admin/android/app` folder
   7. Add your fingerprint to enable debugging (follow steps to do so from https://developers.google.com/android/guides/client-auth).
      You can do this later from Project Settings too

6. Enable Google Sign In and add temp data to Firestore
   
   1. Go to Authentication -> Set up Sign In Method
   2. Enable Google Sign In
   3. Go to Cloud Firestore and create database
   4. Start a collection with Collection ID `extra_access_users`
      Add documents with following fields to give user access to the app.
      1. Document ID: Auto
      2. Fields:
         1. `can_edit: true` (boolean)
         2. `can_get_list: true` (boolean)
         3. `can_live: true` (boolean)
         4. `can_notify: true` (boolean)
         4. `can_scan: true` (boolean)
         4. `email_id: your_mail_id` (string)
   5. Go to Rules and add following rule:
   ```
   // Allow read/write access on all documents to any user signed in to the application 
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if request.auth.uid != null;
       }
     }
   }
   ```
      
7. Run the app in your device or an emulator.
   
## Create Pull Request

1. Create a new branch:
   ```
   git branch new-branch
   ```
2. Checkout new branch:
   ```
   git checkout new-branch
   ```
3. Add, commit and push your changes to the new branch
   ```
   git add .
   git commit -m "changes"
   git push origin new-branch
   ```
4. To make sure your forked repository is up to date with this repository. Add this repository as the upstream repository by doing the following:
```
git remote add upstream https://github.com/developer-student-clubs/DSC-DDU-Admin.git
```
Then, to fetch from this repository:
```
git fetch upstream
git merge upstream/master master
```
5. Go to your forked repository and press the “New pull request” button.
6. Once the pull request is reviewed and approved, it will be merged.

## Code of Conduct

Follow https://developers.google.com/community-guidelines to check the community guidelines.
