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
  'getCurrentPublicWorkoutId' : ActorMethod<[], bigint>,
  'getLatestWorkouts' : ActorMethod<[], Array<[bigint, LatestWorkouts]>>,
  'getMaxPublicWorkouts' : ActorMethod<[], bigint>,
  'getPublicReports' : ActorMethod<[], GetPublicReportsResponse>,
  'getRanking' : ActorMethod<[], Array<GetRankingResponse>>,
  'getUserFeed' : ActorMethod<[], Array<GetUserFeedResponse>>,
  'getUserProfile' : ActorMethod<[], GetUserProfileResponse>,
  'getUserWeeklyStats' : ActorMethod<[], Array<[bigint, WeeklyStats]>>,
  'getWorkoutReports' : ActorMethod<[number], GetWorkoutReportsResponse>,
  'getWorkoutsPerPrincipal' : ActorMethod<[], Array<WorkoutsPerUserResponse>>,
  'getWorkoutsPerRangeReport' : ActorMethod<
    [bigint, bigint],
    WorkoutsPerRangeResponse
  >,
  'removeFriend' : ActorMethod<[string], boolean>,
  'removeUser' : ActorMethod<[Principal], boolean>,
  'removeWorkout' : ActorMethod<[bigint], boolean>,
  'setMaxPublicWorkouts' : ActorMethod<[bigint], boolean>,
  'testNormalizeToWeekStart' : ActorMethod<[bigint], bigint>,
  'updatePoints' : ActorMethod<[Principal, bigint], bigint>,
  'updateProfile' : ActorMethod<[UpdateProfile], boolean>,
}
export type Time = bigint;
export interface UpdateProfile { 'alias' : string, 'size' : number }
export interface WeeklyStats {
  'totalDuration' : bigint,
  'totalWorkouts' : bigint,
}
export interface Workout {
  'duration' : Time,
  'date' : Time,
  'exercises' : Array<Exercise>,
}
export interface WorkoutPayload {
  'duration' : Time,
  'exercises' : Array<Exercise>,
}
export interface WorkoutsPerRangeResponse {
  'totalDuration' : bigint,
  'totalCount' : bigint,
}
export interface WorkoutsPerUserResponse {
  'id' : bigint,
  'duration' : Time,
  'date' : Time,
  'exercises' : Array<Exercise>,
}
export interface _SERVICE extends Main {}
export declare const idlFactory: IDL.InterfaceFactory;
export declare const init: (args: { IDL: typeof IDL }) => IDL.Type[];
