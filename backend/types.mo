import MigrationTypes "./migrations/types";

module {
  let StateTypes = MigrationTypes.Current;

  public type FetchWorkoutResponsePublic = {
    workouts: [StateTypes.Workout];
    totalWorkouts: Nat;
    totalUsers: Nat;
  };

  public type FetchWorkoutResponse = {
    workouts: [StateTypes.Workout];
    totalWorkouts: Nat;
  };


  
};