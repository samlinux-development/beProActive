
import { defineNuxtPlugin } from '#app';

export default defineNuxtPlugin((nuxtApp) => {

  const translate = (key: string): string => {

    const translations: { [key: string]: string } = {
      'index.title': 'Be ProActive',
      'index.hello': 'Check out the newest workout warriors crushing their fitness goals! 💪 Are you ready to join the leaderboard with your own epic sessions?',
      'index.hello2': 'Help to grow the community by sharing your workout achievements! Train with __totalUsers__ other fitness enthusiasts and inspire each other to reach new heights! 🏋️‍♂️',

      'pwa.refresh-button': 'New version available, click to update',
      
      'navigation.menu.about': 'About',
      'navigation.menu.home': 'Home',
      'navigation.menu.github': 'GitHub',
      'navigation.menu.logout': 'Logout',
      'navigation.menu.profile': 'Profile',
      'navigation.menu.leaderboard': 'Ranking',
      'navigation.menu.addWorkout': 'Add workout',
      'navigation.menu.blog': 'Blog',

      'navigation.title': 'Be ProActive',
      'navigation.desc': 'Track your daily workouts and share them with the community and your friends. Stay motivated and inspire others to crush their goals!',
      'workout.title': 'Add new workout',
      'workout.desc': 'Stay Inspired: Discover the latest public workouts completed by our fitness community. See how others are crushing their goals and get motivated to tackle yours!',
      'workout.count': 'Workout performed',
      'workout.hello': 'Amazing job! You’ve crushed __workoutsTotal__ workouts so far! 🚀 Keep up the hard work and push yourself to new heights - you’ve got this!',
      'workout.set': 'Set',
      'workout.addBtn': 'Commit workout',
      'workout.loading': 'storing push-up...',
      'workout.list-title': '🏋️‍♂️ Latest workouts',
      'workout.list-title2': '🏋️‍♂️ Your workouts',
      'workout.list-title3': '🏋️‍♂️ Friend workouts',
      'workout.list-empty': '“😔 No workouts here yet… Be the first to break the silence and inspire the community!”',
      'workout.list-rolling': '🎉 Workouts are rolling in! Check out what your friends has been up to and get inspired to join the action!',
      'workout.list-loading': 'loading push-ups...',
      'workout.by': 'by',
      'workout.at': 'at',
      'workout.kg': 'kg',
      'workout.seconds': 'sec',
      'workout.minutes': 'min',
      'workout.repetition': 'Reps',
      'workout.executionDetails':'Exercises',
      'workout.executionDetails2':'Great job! Go ahead and submit these exercises!',
      'workout.confirm-title':'Ready to submit workout?',
      'workout.delete-title': 'Ready to delete workout?',
      'workout.confirm-text':'Please confirm that you have completed the workout, be honest 😉',
      'workout.delete-text':'Please confirm that you want to delete the workout. This action cannot be undone 😔.',
      'workout.confirm-yes':'Yes, submit',
      'workout.confirm-no':'No, cancel',
      'workout.typeOfExercise':'Exercise',
      'workout.duration':'Duration',
      'workout.workoutDuration':'Your workout duration',
      'workout.manualDuration':'Set manual workout duration?',
      'about.title': 'About this dApp',
      'about.info': 'This dApp helps you to track your daily workouts and share them with the community and your friends. It is a decentralized application (dApp) built on the Internet Computer and it is completely anonymous. Your data is stored on the blockchain and can be changed only by your Internet Identity.',
      'about.info2': 'This dApp is powered by IcAcademy, a part of the samlinux development team. We are a group of developers who are passionate about building on the Internet Computer and sharing our knowledge with the community.',
      'about.stayTuned': 'Stay in the loop with the latest development updates! 🚀 Follow me on <a target="_blank" href="https://x.com/samlinux/status/1874778087377994099">X</a> for real-time progress, or subscribe to our <a target="_blank" href="https://oc.app/community/gmf6e-caaaa-aaaar-beepq-cai/channel/230301923274756934814897448075398376070">OpenChat channel</a> to stay connected. 💬✨',
      'about.frontendBuild': 'Build',
      'about.copyright': 'by IcAcademy',
      'auth.pleaseLoginTitle': 'Please log in',
      'auth.pleaseLoginMessage': 'Access to this page requires to log in with your Internet Identity. Let’s get you started! 🚀',
      'profile.your-friends': 'Your friends:',
      'profile.total-workout': 'workout',
      'profile.total-workouts': 'workouts',
      'profile.total-points': 'points',
      'profile.edit-profile-button': 'Edit Profile',
      'profile.edit-profile-sidebar-title': 'Edit Profile',
      'profile.friends-sidebar-description': 'Add friends to see their workouts and compete with them!',
      'profile.edit-profile-sidebar-submit-button': 'Update',
      'profile.edit-profile-sidebar-alias-input-help': 'Please enter a friendly and unique alias.',
      'profile.edit-profile-sidebar-alias-input-label': 'Alias',
      'profile.edit-profile-sidebar-size-input-label': 'Body size in centimeters',
      'profile.edit-profile-sidebar-size-input-help': 'Please enter your body size for BMI calculation.',
      'profile.edit-profile-sidebar-description': 'Update your profile information to enhance your experience.',
      'profile.friends-sidebar-title': 'Friends',
      
      'profile.friends-sidebar-add-friend': 'Add a friend',
      'profile.friends-sidebar-add-friend-button': 'Add',
      'profile.friends-sidebar-friend-list-header-alias': 'Friends',
      'profile.friends-sidebar-friend-list-header-workouts': 'Workouts',
      'profile.friends-sidebar-friend-list-header-points': 'Points',
      'profile.friends-sidebar-remove-friend-modal-title': 'Remove friend',
      'profile.friends-sidebar-remove-friend-modal-description': 'Do you really want to remove <FRIEND_ALIAS> as a friend?',
      'profile.friends-sidebar-remove-friend-modal-confirm-button': 'Yes',
      'profile.friends-sidebar-remove-friend-modal-cancel-button': 'No',
      'profile.friends-select-noFriendsToAdd': 'No friends to add!',
      'profile.friends-select-selectAFriend': 'Select a friend',
      'button-close': 'Close',
      'ranking.title': '🏆 Leaderboard',
      'ranking.desc': 'Check out the top fitness warriors crushing their workouts! 🚀 Are you ready to join the leaderboard with your own epic sessions?',
      'blog.title': 'Blog about BeProActive',
      'blog.description': 'Read all about the latest news and updates on our blog.',

      'btn-getStarted': 'Learn How to Use the App',

      'getting-started.title': 'Learn How to Use the App',
      'getting-started.desc': 'Here are some steps to get you started:',

      'workout.typeOfExercise0':'Choose exercise',
      'workout.typeOfExercise1':'Push-ups',
      'workout.typeOfExercise2':'Squat',
      'workout.typeOfExercise3':'Bicep Curl (Dumbbell)',
      'workout.typeOfExercise4':'Hammer Curl (Dumbbell)',
      'workout.typeOfExercise5':'Plank',
      'workout.typeOfExercise6':'Superman (Bodyweight)',
      'workout.typeOfExercise7':'Overhead Press (Dumbbell)',
      'workout.typeOfExercise8':'Flat Knee Raise',
      'workout.typeOfExercise9':'Russian Twist',
      'workout.typeOfExercise10':'Yoga',
      'workout.typeOfExercise11':'Crunch',
      'workout.typeOfExercise12':'Leg Raise',
      'workout.typeOfExercise13':'Bicycle Crunch',
      'workout.typeOfExercise14':'Bench Dip',
      'workout.typeOfExercise15':'Chest Dip',
      'workout.typeOfExercise16':'Ring Dip',
      'workout.typeOfExercise17':'Tricpes Dip',
      'workout.typeOfExercise18':'Leg Extension (Maschine)',
      'workout.typeOfExercise19':'Leg Press (Maschine)',
      'workout.typeOfExercise20':'Bench Press (Barbell)',
      'workout.typeOfExercise21':'Bench Press (Dumbbell)',
      'workout.typeOfExercise22':'Bicep Curl (Barbell)',
      'workout.typeOfExercise23':'Reverse Curl (Dumbbell)',
      'workout.typeOfExercise24':'Stretching',
      'workout.typeOfExercise25':'Swimmer (Bodyweight)',
      'workout.typeOfExercise26':'Running',
      'workout.typeOfExercise27':'Cycling',
      'workout.typeOfExercise28':'Swimming',
      'workout.typeOfExercise29':'Burpees',
      'workout.typeOfExercise30':'Walking',
      'workout.typeOfExercise31':'Mountain Climber',
      'workout.typeOfExercise32':'High Knees',
      'workout.typeOfExercise33':'Lunges',
      'workout.typeOfExercise34':'Pilates',
      'workout.typeOfExercise35':'Pull-ups',
      'workout.typeOfExercise36':'Chin-ups',
      'workout.typeOfExercise37':'Shoulder Mobility',
      'workout.typeOfExercise38':'Hip Mobility',
      'workout.typeOfExercise39':'Back Mobility',
      'workout.typeOfExercise40':'Australian Pull-up',
      'workout.typeOfExercise41':'Single-leg Stance',
      'workout.typeOfExercise42':'Knee Push-ups',
      'workout.typeOfExercise43':'Daily Morning Routine',



    };
    return translations[key] || key;
  };

  // Inject $translate(key) in Vue, context, and store.
  nuxtApp.provide('translate', translate);


});
