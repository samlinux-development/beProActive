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
export interface Friend {
  'principal' : Principal,
  'alias' : string,
  'totalWorkouts' : bigint,
}
export interface GetAllUserDataResponse {
  'principal' : Principal,
  'workouts' : Array<WorkoutsPerUserResponse>,
  'userProfile' : GetUserProfileResponse,
}
export interface GetAllUsersResponse {
  'principal' : Principal,
  'alias' : string,
  'totalWorkouts' : bigint,
  'points' : bigint,
}
export interface GetPublicReportsResponse { 'totalUsers' : bigint }
export interface GetRankingResponse {
  'alias' : string,
  'totalWorkouts' : bigint,
  'points' : bigint,
}
export interface GetUserFeedResponse {
  'duration' : Time,
  'alias' : string,
  'date' : Time,
  'exercises' : Array<Exercise>,
}
export interface GetUserProfileResponse {
  'alias' : string,
  'size' : number,
  'totalWorkouts' : bigint,
  'friends' : Array<Friend>,
  'points' : bigint,
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
  'addFriend' : ActorMethod<[string], boolean>,
  'addWorkout' : ActorMethod<[WorkoutPayload], boolean>,
  'createUserProfile' : ActorMethod<[], boolean>,
  'getAllUserData' : ActorMethod<[Principal], [] | [GetAllUserDataResponse]>,
  'getAllUsers' : ActorMethod<[], Array<GetAllUsersResponse>>,
  'getAllWorkouts' : ActorMethod<
    [],
    Array<[Principal, { 'workouts' : Array<[bigint, Workout]> }]>
  >,
  'getLatestWorkouts' : ActorMethod<[], Array<[bigint, LatestWorkouts]>>,
  'getPublicReports' : ActorMethod<[], GetPublicReportsResponse>,
  'getRanking' : ActorMethod<[], Array<GetRankingResponse>>,
  'getUserFeed' : ActorMethod<[], Array<GetUserFeedResponse>>,
  'getUserProfile' : ActorMethod<[], GetUserProfileResponse>,
  'getWorkoutReports' : ActorMethod<[number], GetWorkoutReportsResponse>,
  'getWorkoutsPerPrincipal' : ActorMethod<[], Array<WorkoutsPerUserResponse>>,
  'removeFriend' : ActorMethod<[string], boolean>,
  'removeUser' : ActorMethod<[Principal], boolean>,
  'setMaxPublicWorkouts' : ActorMethod<[bigint], boolean>,
  'updateProfile' : ActorMethod<[UpdateProfile], boolean>,
}
export type Time = bigint;
export interface UpdateProfile { 'alias' : string, 'size' : number }
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
