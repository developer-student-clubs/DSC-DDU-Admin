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
    + [Our Pledge](#our-pledge)
    + [Our Standards](#our-standards)
    + [Our Responsibilities](#our-responsibilities)
    + [Scope](#scope)
    + [Enforcement](#enforcement)

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

### Our Pledge

In the interest of fostering an open and welcoming environment, we as
contributors and maintainers pledge to make participation in our project and
our community a harassment-free experience for everyone, regardless of age, body
size, disability, ethnicity, gender identity and expression, level of experience,
nationality, personal appearance, race, religion, or sexual identity and
orientation.

### Our Standards

Examples of behavior that contributes to creating a positive environment
include:

* Using welcoming and inclusive language
* Being respectful of differing viewpoints and experiences
* Gracefully accepting constructive criticism
* Focusing on what is best for the community
* Showing empathy towards other community members

Examples of unacceptable behavior by participants include:

* The use of sexualized language or imagery and unwelcome sexual attention or
advances
* Trolling, insulting/derogatory comments, and personal or political attacks
* Public or private harassment
* Publishing others' private information, such as a physical or electronic
  address, without explicit permission
* Other conduct which could reasonably be considered inappropriate in a
  professional setting

### Our Responsibilities

Project maintainers are responsible for clarifying the standards of acceptable
behavior and are expected to take appropriate and fair corrective action in
response to any instances of unacceptable behavior.

Project maintainers have the right and responsibility to remove, edit, or
reject comments, commits, code, wiki edits, issues, and other contributions
that are not aligned to this Code of Conduct, or to ban temporarily or
permanently any contributor for other behaviors that they deem inappropriate,
threatening, offensive, or harmful.

### Scope

This Code of Conduct applies both within project spaces and in public spaces
when an individual is representing the project or its community. Examples of
representing a project or community include using an official project e-mail
address, posting via an official social media account, or acting as an appointed
representative at an online or offline event. Representation of a project may be
further defined and clarified by project maintainers.

### Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be
reported by contacting the project team at [INSERT EMAIL ADDRESS]. All
complaints will be reviewed and investigated and will result in a response that
is deemed necessary and appropriate to the circumstances. The project team is
obligated to maintain confidentiality with regard to the reporter of an incident.
Further details of specific enforcement policies may be posted separately.

Project maintainers who do not follow or enforce the Code of Conduct in good
faith may face temporary or permanent repercussions as determined by other
members of the project's leadership.
