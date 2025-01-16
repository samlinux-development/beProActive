import Map "mo:map/Map";
import Nat "mo:base/Nat";
import Nat16 "mo:base/Nat16";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Text "mo:base/Text";

module {
  
  public type WorkoutPayload = {
    duration: Time.Time;
    exercises : [Exercise];
  };

  public type WorkoutToStore = {
    workouts : Map.Map<Nat,Workout>;
  };

  public type Workout = {
    date: Time.Time;
    duration: Time.Time;
    exercises : [Exercise];
  }; 

  public type Exercise = {
    //nat16 = 0-65535
    typeOfExercise : Nat16;
    set : Nat16;
    repetition: Nat16;
    kg: Nat16;
    seconds: Nat;
  };

  public type User = {
    alias : Text;
    friends : Map.Map<Principal,Text>;
  };

  public type LatestWorkouts = {
    alias: Text;
    date: Time.Time;
    exercises : [Exercise];
  };

  public type Like = {
    alias: Text;
    principal: Principal;
  };

  public type State = {
    var maxPublicWorkouts: Nat;
    var map: Map.Map<Principal, WorkoutToStore>;
    var users: Map.Map<Principal, User>;
    var latestWorkouts: Map.Map<Nat, LatestWorkouts>;
  };

}