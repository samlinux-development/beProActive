export const idlFactory = ({ IDL }) => {
  const Exercise = IDL.Record({
    'kg' : IDL.Nat16,
    'set' : IDL.Nat16,
    'seconds' : IDL.Nat,
    'typeOfExercise' : IDL.Nat16,
    'repetition' : IDL.Nat16,
  });
  const Time = IDL.Int;
  const Workout = IDL.Record({
    'date' : Time,
    'exercises' : IDL.Vec(Exercise),
    'user' : IDL.Principal,
  });
  const FetchWorkoutResponsePublic = IDL.Record({
    'workouts' : IDL.Vec(Workout),
    'totalWorkouts' : IDL.Nat,
    'totalUsers' : IDL.Nat,
  });
  const FetchWorkoutResponse = IDL.Record({
    'workouts' : IDL.Vec(Workout),
    'totalWorkouts' : IDL.Nat,
  });
  const Main = IDL.Service({
    'addWorkout' : IDL.Func([IDL.Vec(Exercise)], [IDL.Bool], []),
    'createUserProfile' : IDL.Func([], [IDL.Bool], []),
    'getPublicWorkouts' : IDL.Func([], [FetchWorkoutResponsePublic], ['query']),
    'getWorkoutsPerPrincipal' : IDL.Func([], [FetchWorkoutResponse], ['query']),
    'setMaxPublicWorkouts' : IDL.Func([IDL.Nat], [IDL.Bool], []),
  });
  return Main;
};
export const init = ({ IDL }) => { return []; };
