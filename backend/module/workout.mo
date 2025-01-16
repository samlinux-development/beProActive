//import V0_1_0 "../migrations/00-01-00-initial/types";
import MigrationTypes "../migrations/types";

import Map "mo:map/Map";
import { phash } "mo:map/Map";
import { nhash } "mo:map/Map";

import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
//import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Helper "helper";


module {
  let StateTypes = MigrationTypes.Current;

  // add a new workout to the user's workout map
  public func addWorkout(
    caller:Principal, 
    workout: StateTypes.WorkoutPayload, 
    map: Map.Map<Principal, StateTypes.WorkoutToStore>,
    latestWorkout: Map.Map<Nat, StateTypes.LatestWorkouts>,
    users: Map.Map<Principal, StateTypes.User>,
    maxPublicWorkouts:Nat) : async Bool {

    if (Map.contains(map, phash, caller) == ?true){
      let wOpt = Map.get(map, phash, caller);
      switch (wOpt) {
        case (?w) {
          // add new workout
          let newWorkout:StateTypes.Workout = {
            date = Time.now();
            duration = workout.duration;
            exercises = workout.exercises;
          };

          let newWorkoutCount:Nat = Map.size(w.workouts)+1;
          //Debug.print("Size "#debug_show(newWorkoutCount));
          Map.set(w.workouts, nhash, newWorkoutCount, newWorkout);

          // add latest workout
          let _r = await addLatestWorkout(caller, newWorkout, latestWorkout, users, newWorkoutCount, maxPublicWorkouts);
        };
        case (null) {
          //Debug.print("Workout not found for user");
        };
      };

      //Debug.print("New Workout added");
      return true;
    } 
    else {
      // create a new workout map
      let w  = Map.new<Nat, StateTypes.Workout>();
      let newWorkout:StateTypes.Workout = {
        date = Time.now();
        duration = workout.duration;
        exercises = workout.exercises;
      };
      // store the new workout
      Map.set(w, nhash, 1, newWorkout);

      let workoutToStore:StateTypes.WorkoutToStore = {
        workouts = w;
      };
     
      // add to the workout map
      Map.set(map, phash, caller, workoutToStore);

      // add latest workout
      let _r = await addLatestWorkout(caller, newWorkout, latestWorkout, users, 1, maxPublicWorkouts);

      //Debug.print("First Workout added");
      return true;
    }
  };

  // and latest workout and removes the oldest if the max size is reached
  // this is a capped map for the public view
  func addLatestWorkout(
    caller:Principal, 
    workout: StateTypes.Workout, 
    latestWorkout: Map.Map<Nat, StateTypes.LatestWorkouts>,
    users: Map.Map<Principal, StateTypes.User>,
    newWorkoutCount:Nat,
    maxPublicWorkouts:Nat) : async Bool{
    
    let alias = getAlias(caller, users);
    let newWorkout:StateTypes.LatestWorkouts = {
      alias = alias;
      date = workout.date;
      exercises = workout.exercises;
    };

    Map.set(latestWorkout, nhash, newWorkoutCount, newWorkout);
    //Debug.print("workout added to latestWorkouts "#debug_show(newWorkout));
    //Debug.print("new workout count "#debug_show(newWorkoutCount));
    let sizeOfLatestWorkouts = Map.size(latestWorkout);

    // Remove the oldest workouts if the max size is reached
    if (sizeOfLatestWorkouts > maxPublicWorkouts) {
      let keys = Iter.toArray(Map.keys(latestWorkout));
      let sortedKeys = Array.sort<Nat>(keys, func (a, b) {
        if (a < b) {
          #less
        } else if (a > b) {
          #greater
        } else {
          #equal
        }
      });
      let oldest = sortedKeys[0];
      //Debug.print("Removing oldest workout "#debug_show(oldest));
      ignore Map.remove(latestWorkout, nhash, oldest);

    };
    return true;
  };

  // get alias for principal if available
  func getAlias(principal:Principal, users: Map.Map<Principal, StateTypes.User>) : Text {
    switch (Map.get(users, phash, principal)) {
      case (?u) {
        switch (u.alias) {
          case ("") {
            return Helper.getAliasFromPrincipal(principal);
          };
          case (alias) {
            return alias;
          };
        };
      };
      case (null) {
        return Helper.getAliasFromPrincipal(principal);
      };
    };
  };
}