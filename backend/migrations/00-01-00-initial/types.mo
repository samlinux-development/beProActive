import Map "mo:map/Map";
import Nat "mo:base/Nat";
import Nat16 "mo:base/Nat16";
import Time "mo:base/Time";
import Principal "mo:base/Principal";

module {
  public type Counter = Nat ;

  public type Exercise = {
    //nat16 = 0-65535
    typeOfExercise : Nat16;
    set : Nat16;
    repetition: Nat16;
    kg: Nat16;
    seconds: Nat;
  };

  public type Workout = {
    user : Principal;
    date : Time.Time;
    exercises : [Exercise];
  }; 

  public type User = {
    alias : Text;
  };

  public type State = {
    var counter: Counter;
    var maxPublicWorkouts: Nat;
    var map: Map.Map<Nat, Workout>;
    var users: Map.Map<Principal, User>;
  };

}