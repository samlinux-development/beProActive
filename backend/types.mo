import MigrationTypes "./migrations/types";

import Time "mo:base/Time";
import Nat "mo:base/Nat";

module {
  let StateTypes = MigrationTypes.Current;

  public type GetWorkoutReportsResponse = {
    totalSetsPerExercise:Nat16; 
    totalRepsPerExercise:Nat16; 
    totalWorkouts:Nat; 
    totalExercises:Nat
  };

  public type WorkoutsPerUserResponse = {
    date : Time.Time; 
    duration : Time.Time; 
    exercises : [StateTypes.Exercise]
  };

  public type GetPublicReportsResponse = {
    totalUsers:Nat;
  };

  public type GetUserProfileResponse = {
    alias: Text;
    friends: [Principal];
    totalWorkouts: Nat;
  };
  
  public type Feed = {
    alias: Text;
    workouts : [(Nat,StateTypes.Workout)];
  };
};