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
export interface Feed {
  'workouts' : Array<[bigint, Workout]>,
  'alias' : string,
}
export interface GetPublicReportsResponse { 'totalUsers' : bigint }
export interface GetUserProfileResponse {
  'alias' : string,
  'totalWorkouts' : bigint,
  'friends' : Array<Principal>,
}
export interface GetWorkoutReportsResponse {
  'totalSetsPerExercise' : number,
  'totalExercises' : bigint,
  'totalWorkouts' : bigint,
  'totalRepsPerExercise' : number,
}
export interface LatestWorkouts {
  'alias' : string,
  'date' : Time,
  'exercises' : Array<Exercise>,
}
export interface Main {
  'addFriend' : ActorMethod<[Principal], boolean>,
  'addWorkout' : ActorMethod<[WorkoutPayload], boolean>,
  'createUserProfile' : ActorMethod<[], boolean>,
  'getAllUsers' : ActorMethod<[], Array<[Principal, string]>>,
  'getAllWorkouts' : ActorMethod<
    [],
    Array<[Principal, { 'workouts' : Array<[bigint, Workout]> }]>
  >,
  'getLatestWorkouts' : ActorMethod<[], Array<[bigint, LatestWorkouts]>>,
  'getPublicReports' : ActorMethod<[], GetPublicReportsResponse>,
  'getUserFeed' : ActorMethod<[], Array<[Principal, Feed]>>,
  'getUserProfile' : ActorMethod<[], GetUserProfileResponse>,
  'getWorkoutReports' : ActorMethod<[number], GetWorkoutReportsResponse>,
  'getWorkoutsPerPrincipal' : ActorMethod<[], Array<WorkoutsPerUserResponse>>,
  'removeFriend' : ActorMethod<[Principal], boolean>,
  'setMaxPublicWorkouts' : ActorMethod<[bigint], boolean>,
  'updateProfile' : ActorMethod<[string], boolean>,
}
export type Time = bigint;
export interface Workout {
  'duration' : Time,
  'date' : Time,
  'exercises' : Array<Exercise>,
}
export interface WorkoutPayload {
  'duration' : Time,
  'exercises' : Array<Exercise>,
}
export interface WorkoutsPerUserResponse {
  'duration' : Time,
  'date' : Time,
  'exercises' : Array<Exercise>,
}
export interface _SERVICE extends Main {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
