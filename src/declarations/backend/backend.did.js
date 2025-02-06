export const idlFactory = ({ IDL }) => {
  const Time = IDL.Int;
  const Exercise = IDL.Record({
    'kg' : IDL.Nat16,
    'set' : IDL.Nat16,
    'seconds' : IDL.Nat,
    'typeOfExercise' : IDL.Nat16,
    'repetition' : IDL.Nat16,
  });
  const WorkoutPayload = IDL.Record({
    'duration' : Time,
    'exercises' : IDL.Vec(Exercise),
  });
  const WorkoutsPerUserResponse = IDL.Record({
    'id' : IDL.Nat,
    'duration' : Time,
    'date' : Time,
    'exercises' : IDL.Vec(Exercise),
  });
  const Friend = IDL.Record({
    'principal' : IDL.Principal,
    'alias' : IDL.Text,
    'totalWorkouts' : IDL.Nat,
  });
  const GetUserProfileResponse = IDL.Record({
    'alias' : IDL.Text,
    'size' : IDL.Nat16,
    'totalWorkouts' : IDL.Nat,
    'friends' : IDL.Vec(Friend),
    'points' : IDL.Nat,
  });
  const GetAllUserDataResponse = IDL.Record({
    'principal' : IDL.Principal,
    'workouts' : IDL.Vec(WorkoutsPerUserResponse),
    'userProfile' : GetUserProfileResponse,
  });
  const GetAllUsersResponse = IDL.Record({
    'principal' : IDL.Principal,
    'alias' : IDL.Text,
    'totalWorkouts' : IDL.Nat,
    'points' : IDL.Nat,
  });
  const Workout = IDL.Record({
    'duration' : Time,
    'date' : Time,
    'exercises' : IDL.Vec(Exercise),
  });
  const LatestWorkouts = IDL.Record({
    'alias' : IDL.Text,
    'date' : Time,
    'exercises' : IDL.Vec(Exercise),
  });
  const GetPublicReportsResponse = IDL.Record({ 'totalUsers' : IDL.Nat });
  const GetRankingResponse = IDL.Record({
    'alias' : IDL.Text,
    'totalWorkouts' : IDL.Nat,
    'points' : IDL.Nat,
  });
  const GetUserFeedResponse = IDL.Record({
    'duration' : Time,
    'alias' : IDL.Text,
    'date' : Time,
    'exercises' : IDL.Vec(Exercise),
  });
  const GetWorkoutReportsResponse = IDL.Record({
    'totalSetsPerExercise' : IDL.Nat16,
    'totalExercises' : IDL.Nat,
    'totalWorkouts' : IDL.Nat,
    'totalRepsPerExercise' : IDL.Nat16,
  });
  const UpdateProfile = IDL.Record({ 'alias' : IDL.Text, 'size' : IDL.Nat16 });
  const Main = IDL.Service({
    'addFriend' : IDL.Func([IDL.Text], [IDL.Bool], []),
    'addWorkout' : IDL.Func([WorkoutPayload], [IDL.Bool], []),
    'createUserProfile' : IDL.Func([], [IDL.Bool], []),
    'getAllUserData' : IDL.Func(
        [IDL.Principal],
        [IDL.Opt(GetAllUserDataResponse)],
        ['query'],
      ),
    'getAllUsers' : IDL.Func([], [IDL.Vec(GetAllUsersResponse)], ['query']),
    'getAllWorkouts' : IDL.Func(
        [],
        [
          IDL.Vec(
            IDL.Tuple(
              IDL.Principal,
              IDL.Record({ 'workouts' : IDL.Vec(IDL.Tuple(IDL.Nat, Workout)) }),
            )
          ),
        ],
        ['query'],
      ),
    'getCurrentPublicWorkoutId' : IDL.Func([], [IDL.Nat], ['query']),
    'getLatestWorkouts' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Nat, LatestWorkouts))],
        ['query'],
      ),
    'getMaxPublicWorkouts' : IDL.Func([], [IDL.Nat], ['query']),
    'getPublicReports' : IDL.Func([], [GetPublicReportsResponse], ['query']),
    'getRanking' : IDL.Func([], [IDL.Vec(GetRankingResponse)], ['query']),
    'getUserFeed' : IDL.Func([], [IDL.Vec(GetUserFeedResponse)], ['query']),
    'getUserProfile' : IDL.Func([], [GetUserProfileResponse], ['query']),
    'getWorkoutReports' : IDL.Func(
        [IDL.Nat16],
        [GetWorkoutReportsResponse],
        ['query'],
      ),
    'getWorkoutsPerPrincipal' : IDL.Func(
        [],
        [IDL.Vec(WorkoutsPerUserResponse)],
        ['query'],
      ),
    'removeFriend' : IDL.Func([IDL.Text], [IDL.Bool], []),
    'removeUser' : IDL.Func([IDL.Principal], [IDL.Bool], []),
    'removeWorkout' : IDL.Func([IDL.Nat], [IDL.Bool], []),
    'setMaxPublicWorkouts' : IDL.Func([IDL.Nat], [IDL.Bool], []),
    'updatePoints' : IDL.Func([IDL.Principal, IDL.Nat], [IDL.Nat], []),
    'updateProfile' : IDL.Func([UpdateProfile], [IDL.Bool], []),
  });
  return Main;
};
export const init = ({ IDL }) => { return []; };
