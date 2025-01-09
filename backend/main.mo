import Debug "mo:base/Debug";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Bool "mo:base/Bool";
import MigrationTypes "./migrations/types";
import Migrations "./migrations";
import Types "./types";
import Error "mo:base/Error";
import Buffer "mo:base/Buffer";

import Map "mo:map/Map";
import { nhash } "mo:map/Map";
import { phash } "mo:map/Map";

shared ({ caller = creator }) actor class Main () {
  
  let StateTypes = MigrationTypes.Current;
  
  // you will have only one stable variable
  // move all your stable variable declarations to "migrations/001-initial/types.mo -> State"
  stable var migrationState: MigrationTypes.State = #v0_0_0(#data);

  // do not forget to change #v0_1_0 when you are adding a new migration
  // if you use one of previus states in place of #v0_1_0 it will run downgrade methods instead
  migrationState := Migrations.migrate(migrationState, #v0_1_0(#id), { creator });

  // do not forget to change #v0_1_0 when you are adding a new migration
  let state = switch (migrationState) { case (#v0_1_0(#data(state))) state; case (_) Debug.trap("Unexpected migration state") };

  public shared ({caller}) func addWorkout(exercises:[StateTypes.Exercise]) : async Bool {
    let workout:StateTypes.Workout = {
      user = caller; 
      date = Time.now();
      exercises = exercises;
    };

    try {
      Map.set(state.map, nhash, state.counter, workout);
      state.counter := state.counter + 1;
      return true;
    } catch (e) {
      let message = Error.message(e);
      Debug.print("Error: "# message);
      return false;
    };
  };

  // get public workouts
  public query func getPublicWorkouts() : async Types.FetchWorkoutResponsePublic {
    let buffer = Buffer.Buffer<(Nat, StateTypes.Workout)>(0);
    var count = 0;
    for ((key, value) in Map.entries(state.map)) {
      switch (?value) {
        case (?value) {
        if (count >= state.maxPublicWorkouts) {
            //
            return {
              workouts = Array.map<(Nat, StateTypes.Workout), StateTypes.Workout>(Buffer.toArray(buffer), func(tuple) { tuple.1 });
              totalWorkouts = count;
              totalUsers = Map.size(state.users);
            };
        };
        buffer.add((key, value));
        count := count + 1;
        };
        case null {};
      };
    };

    {
      workouts = Array.map<(Nat, StateTypes.Workout), StateTypes.Workout>(Buffer.toArray(buffer), func(tuple) { tuple.1 });
      totalWorkouts = (state.counter -1);
      totalUsers = Map.size(state.users);
    }

  };

  // get all workouts per user
  public shared query ({caller}) func getWorkoutsPerPrincipal() : async Types.FetchWorkoutResponse {
    let buffer = Buffer.Buffer<StateTypes.Workout>(0);

    for (value in Map.vals(state.map)) {
      switch (?value) {
        case (?value) {
          if (value.user == caller) {
            buffer.add(value);
          };
        };
        case null {};
      };

    };
    
    let items = Buffer.toArray(buffer);
    return {
      workouts = items;
      totalWorkouts = buffer.size();
    };
  };

  // set maxPublicWorkouts limit
  public shared ({caller}) func setMaxPublicWorkouts(limit: Nat) : async Bool {
    // only creator can set the limit
    try {
      if (caller != creator) {
        return false;
      };
      state.maxPublicWorkouts := limit;
      true;
    } 
    catch(e) {
      let message = Error.message(e);
      Debug.print("Error: "# message);
      false;
    };
  };
  
  // collect all users for stats and/or profile
  public shared ({caller}) func createUserProfile(): async Bool {
    try {
      if (Map.has(state.users, phash, caller) == false) {
        let user:StateTypes.User = {
          alias = ""; 
        };
        Map.set(state.users, phash, caller, user);
        true;
      } else {
        false;
      };
    } catch(e) {
      let message = Error.message(e);
      Debug.print("Error: "# message);
      false;
    };
  };

}
