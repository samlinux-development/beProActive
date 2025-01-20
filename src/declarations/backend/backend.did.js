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
  const GetAllUsersResponse = IDL.Record({
    'principal' : IDL.Principal,
    'alias' : IDL.Text,
    'totalWorkouts' : IDL.Nat,
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
  const Feed = IDL.Record({
    'workouts' : IDL.Vec(IDL.Tuple(IDL.Nat, Workout)),
    'alias' : IDL.Text,
  });
  const Friend = IDL.Record({
    'principal' : IDL.Principal,
    'alias' : IDL.Text,
  });
  const GetUserProfileResponse = IDL.Record({
    'alias' : IDL.Text,
    'totalWorkouts' : IDL.Nat,
    'friends' : IDL.Vec(Friend),
  });
  const GetWorkoutReportsResponse = IDL.Record({
    'totalSetsPerExercise' : IDL.Nat16,
    'totalExercises' : IDL.Nat,
    'totalWorkouts' : IDL.Nat,
    'totalRepsPerExercise' : IDL.Nat16,
  });
  const WorkoutsPerUserResponse = IDL.Record({
    'duration' : Time,
    'date' : Time,
    'exercises' : IDL.Vec(Exercise),
  });
  const Main = IDL.Service({
    'addFriend' : IDL.Func([IDL.Principal], [IDL.Bool], []),
    'addWorkout' : IDL.Func([WorkoutPayload], [IDL.Bool], []),
    'createUserProfile' : IDL.Func([], [IDL.Bool], []),
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
    'getLatestWorkouts' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Nat, LatestWorkouts))],
        ['query'],
      ),
    'getPublicReports' : IDL.Func([], [GetPublicReportsResponse], ['query']),
    'getUserFeed' : IDL.Func(
        [],
        [IDL.Vec(IDL.Tuple(IDL.Principal, Feed))],
        ['query'],
      ),
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
    'removeFriend' : IDL.Func([IDL.Principal], [IDL.Bool], []),
    'setMaxPublicWorkouts' : IDL.Func([IDL.Nat], [IDL.Bool], []),
    'updateProfile' : IDL.Func([IDL.Text], [IDL.Bool], []),
  });
  return Main;
};
export const init = ({ IDL }) => { return []; };
