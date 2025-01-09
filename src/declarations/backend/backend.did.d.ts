import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface Exercise {
  'kg' : number,
  'set' : number,
  'seconds' : bigint,
  'typeOfExercise' : number,
  'repetition' : number,
}
export interface FetchWorkoutResponse {
  'workouts' : Array<Workout>,
  'totalWorkouts' : bigint,
}
export interface FetchWorkoutResponsePublic {
  'workouts' : Array<Workout>,
  'totalWorkouts' : bigint,
  'totalUsers' : bigint,
}
export interface Main {
  'addWorkout' : ActorMethod<[Array<Exercise>], boolean>,
  'createUserProfile' : ActorMethod<[], boolean>,
  'getPublicWorkouts' : ActorMethod<[], FetchWorkoutResponsePublic>,
  'getWorkoutsPerPrincipal' : ActorMethod<[], FetchWorkoutResponse>,
  'setMaxPublicWorkouts' : ActorMethod<[bigint], boolean>,
}
export type Time = bigint;
export interface Workout {
  'date' : Time,
  'exercises' : Array<Exercise>,
  'user' : Principal,
}
export interface _SERVICE extends Main {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
