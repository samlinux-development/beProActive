import { NuxtApp } from '#app';

import { ActorSubclass } from '@dfinity/agent';
import { _SERVICE } from '../src/declarations/backend/backend.did';

declare module '#app' {
  interface NuxtApp {
    $getActor(): ActorSubclass<_SERVICE>;
  }

  interface NuxtApp {
    $translate(key: string): string;
  }
}