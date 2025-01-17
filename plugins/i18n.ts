
import { defineNuxtPlugin } from '#app';

export default defineNuxtPlugin((nuxtApp) => {

  const translate = (key: string): string => {

    const translations: { [key: string]: string } = {
      'index.title': 'Be ProActive',
      'index.hello': 'Check out the newest workout warriors crushing their fitness goals! 💪 Are you ready to join the leaderboard with your own epic sessions?',
      'index.hello2': 'Help to grow the community by sharing your workout achievements! Train with __totalUsers__ other fitness enthusiasts and inspire each other to reach new heights! 🏋️‍♂️',
      'workout.title': 'Add new workout',
      'workout.count': 'Workout performed',
      'workout.hello': '🎉 Amazing job! You’ve crushed __workoutsTotal__ workouts so far! 🚀 Keep up the hard work and push yourself to new heights - you’ve got this!',
      'workout.set': 'Set',
      'workout.addBtn': 'Commit workout',
      'workout.loading': 'storing push-up...',
      'workout.list-title': '🏋️‍♂️ Latest workouts',
      'workout.list-title2': '🏋️‍♂️ Your workouts',
      'workout.list-empty': '💪 No workouts yet? Let’s get moving and crush your first session! 🚀',
      'workout.list-loading': 'loading push-ups...',
      'workout.by': 'by',
      'workout.at': 'at',
      'workout.kg': 'kg',
      'workout.seconds': 'sec',
      'workout.minutes': 'min',
      'workout.repetition': 'Reps',
      'workout.executionDetails':'Exercises',
      'workout.confirm-title':'Ready to submit workout?',
      'workout.confirm-text':'Please confirm that you have completed the workout, be honest 😉',
      'workout.confirm-yes':'Yes, submit',
      'workout.confirm-no':'No, cancel',
      'workout.typeOfExercise':'Exercise',
      'about.title': 'About this dApp',
      'about.info': 'This dApp helps you to track your daily workouts and share them with the community. It is a decentralized application (dApp) built on the Internet Computer.',
      'about.info2': 'This dApp is powered by IcAcademy, a part of the samlinux development team. We are a group of developers who are passionate about building on the Internet Computer and sharing our knowledge with the community.',
      'about.stayTuned': 'Stay in the loop with the latest development updates! 🚀 Follow me on <a target="_blank" href="https://x.com/samlinux/status/1874778087377994099">X</a> for real-time progress, or subscribe to our <a target="_blank" href="https://oc.app/community/gmf6e-caaaa-aaaar-beepq-cai/channel/230301923274756934814897448075398376070">OpenChat channel</a> to stay connected. 💬✨',
      'auth.pleaseLoginTitle': 'Please log in',
      'auth.pleaseLoginMessage': 'Access to this page requires to log in with your Internet Identity. Let’s get you started! 🚀',
      'profile.your-friends': 'Your friends:',
      'profile.total-workout': 'workout',
      'profile.total-workouts': 'workouts',
      'profile.edit-profile-button': 'Edit Profile',
      'profile.edit-profile-sidebar-title': 'Edit Profile',
      'profile.edit-profile-sidebar-submit-button': 'Submit',
      'profile.edit-profile-sidebar-alias-input-help': 'Please enter a nice alias.',
      'profile.edit-profile-sidebar-alias-input-label': 'Alias',
      'profile.friends-sidebar-title': 'Friends',
      'profile.friends-sidebar-add-friend': 'Add a friend',
      'profile.friends-sidebar-add-friend-button': 'Add friend',
      'profile.friends-sidebar-friend-list': 'Friend list',
      'profile.friends-sidebar-friend-list-header-alias': 'Alias',

      'workout.typeOfExercise0':'Choose exercise',
      'workout.typeOfExercise1':'Push ups',
      'workout.typeOfExercise2':'Sqaut',
      'workout.typeOfExercise3':'Bicep curl (Dumbbell)',
      'workout.typeOfExercise4':'Hammer curl (Dumbbell)',
      'workout.typeOfExercise5':'Plank',
      'workout.typeOfExercise6':'Superman',
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
      'workout.typeOfExercise25':'Swimmer',

    };
    return translations[key] || key;
  };

  // Inject $translate(key) in Vue, context, and store.
  nuxtApp.provide('translate', translate);


});
