<script setup lang="ts">

const { $translate } = useNuxtApp();

const items = ref([
  {
    label: 'Sign up for an account',
    icon: 'i-lucide-smile',
    slot: 'signup'
  },
  {
    label: 'Log in to your account',
    icon: 'i-lucide-log-in',
    slot: 'login'
  },
  {
    label: 'Set up your profile',
    icon: 'i-lucide-settings',
    slot: 'setup'
  },
  {
    label: 'Start tracking your workouts',
    icon: 'i-lucide-dumbbell',
    slot: 'start'
  }
])
</script>

<template>
  <div>
    <h1>{{ $translate ('getting-started.title') }}</h1>
    <div>
      <p>{{ $translate ('getting-started.desc') }}</p>
      <div class="flex flex-col space-y-4">

        <UAccordion :items="items">
          <template #signup>
            <div>
              <p>
              Sign up for an account using Internet Identity. Follow the instructions provided on the linked page to set up your Internet Identity. <a href="https://identitysupport.dfinity.org/hc/en-us/articles/15736848674580-How-do-I-create-an-Internet-Identity" target="_blank">How do I create an Internet Identity?</a>
            </p>
            <p>
              The application does not store any personal information. All data is securely stored on the Internet Computer blockchain. Your Internet Identity is used solely for authentication and to save your workouts to your account. We do not manage your identity or have the ability to link your personal identity to your workouts.
            </p>
          </div>
          </template>

          <template #login>
            <div>
            <p>
              After creating your account, log in to the app using your Internet Identity. Your personal profile will be generated automatically, and all your workouts will be saved to your account.
            </p>
            <p>
              You can also install this dApp as a Progressive Web App (PWA) on your mobile device, allowing quick and easy access directly from your home screen.
            </p>
          </div>
          </template>

          <template #setup>
            <div>
              <p>
                Set up your profile by entering your alias and height. This information will be used to calculate your BMI and other health metrics.
              </p>
              <p>
                You can add our friends to your feed and view their latest workouts. You can also view your workout history and track your progress over time.
              </p>
            </div>  
          </template>

          <template #start>
            <div>
              <p>
                Start tracking your workouts by selecting the + button in the navigation bar. We have a variety of workouts to choose from, including cardio, strength training, and yoga.
              </p>
            </div>
          </template>

        </UAccordion>

      </div>
      
    </div>
  </div>
</template>

<script lang="ts" setup></script>
