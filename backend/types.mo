import MigrationTypes "./migrations/types";

import Time "mo:base/Time";
import Nat "mo:base/Nat";
import Nat16 "mo:base/Nat16";
import Principal "mo:base/Principal";
import Text "mo:base/Text";

module {
  let StateTypes = MigrationTypes.Current;

  public type GetWorkoutReportsResponse = {
    totalSetsPerExercise:Nat16; 
    totalRepsPerExercise:Nat16; 
    totalWorkouts:Nat; 
    totalExercises:Nat;
  };

  public type WorkoutsPerUserResponse = {
    id : Nat;
    date : Time.Time; 
    duration : Time.Time; 
    exercises : [StateTypes.Exercise];
  };

  public type GetPublicReportsResponse = {
    totalUsers:Nat;
  };

  public type GetUserProfileResponse = {
    alias: Text;
    size:Nat16;
    friends: [Friend];
    totalWorkouts: Nat;
    points: Nat;
  };

  public type Friend = {
    principal: Principal;
    alias: Text;
    totalWorkouts:Nat;
  };
  
  public type Feed = {
    alias: Text;
    workouts : [(Nat,StateTypes.Workout)];
  };

  public type GetAllUsersResponse = {
    principal:Principal; 
    alias:Text;
    totalWorkouts:Nat;
    points:Nat;
  };

  public type GetRankingResponse = {
    alias:Text;
    totalWorkouts:Nat;
    points:Nat;
  };

  public type GetUserFeedResponse = {
    alias: Text;
    date: Time.Time;
    duration: Time.Time;
    exercises : [StateTypes.Exercise];
  };

  public type GetAllUserDataResponse = {
    principal:Principal;
    userProfile:GetUserProfileResponse;
    workouts:[WorkoutsPerUserResponse];
  };

  public type UpdateProfile = {
    alias: Text;
    size: Nat16;
  };
};