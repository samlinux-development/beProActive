import Debug "mo:base/Debug";
import Bool "mo:base/Bool";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";

import MigrationTypes "./migrations/types";
import Migrations "./migrations";
import Types "./types";

import Map "mo:map/Map";
import { phash } "mo:map/Map";

import User "module/user";
import Workout "module/workout";


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

  //----------------------------------
  // public methods
  //----------------------------------
  // get latest workouts
  public shared query func getLatestWorkouts(): async [(Nat, StateTypes.LatestWorkouts)]{
    let buffer = Buffer.Buffer<(Nat,StateTypes.LatestWorkouts)>(1);
    for ((key, value) in Map.entries(state.latestWorkouts)) {
      buffer.add((key,value));
    };
    Buffer.toArray(buffer);
  };

  // get all public reports
  public query func getPublicReports(): async Types.GetPublicReportsResponse{
    let users = Map.size(state.users);

    {
      totalUsers = users;
    }
  };

  // ----------------------------------
  // only for creator
  // ----------------------------------
  // set maxPublicWorkouts limit for latest workouts
  public shared ({caller}) func setMaxPublicWorkouts(limit: Nat) : async Bool {
    // Only the creator can set the limit
    if (caller != creator) {
        return false;
    };

    state.maxPublicWorkouts := limit;
    return true;
  };

  // get all workouts
  public shared query ({caller}) func getAllWorkouts(): async [(Principal, {workouts: [(Nat, StateTypes.Workout)]})]{
    if (caller != creator) {return [];};
  
    let buffer = Buffer.Buffer<(Principal, {workouts: [(Nat, StateTypes.Workout)]})>(1);
    for ((key, value) in Map.entries(state.map)) {
      let workoutsArray = Map.toArray(value.workouts);
      buffer.add((key, {workouts = workoutsArray}));
    };
    Buffer.toArray(buffer);
  };

  //----------------------------------
  // only for authenticate users
  //----------------------------------
  // add a new workout to the user's workout map
  public shared ({caller}) func addWorkout(workout: StateTypes.WorkoutPayload) : async Bool{
    if(Principal.isAnonymous(caller)) {return false;};
    await Workout.addWorkout(caller, workout, state.map, state.latestWorkouts, state.users, state.maxPublicWorkouts);
  };

  // get all workouts per principal
  public shared query ({caller}) func getWorkoutsPerPrincipal(): async [Types.WorkoutsPerUserResponse]{
    if(Principal.isAnonymous(caller)) {return []};

    let buffer = Buffer.Buffer<(Types.WorkoutsPerUserResponse)>(1);
    if (Map.contains(state.map, phash, caller) == ?true){
      let wOpt = Map.get(state.map, phash, caller);
      switch (wOpt) {
        case (?w) {
          for (value in Map.vals(w.workouts)) {
            buffer.add(value);
          };
        };
        case (null) {
          //Debug.print("Workout not found");
        };
      };
     };
    Buffer.toArray(buffer);
  };

  // get workout reports for principal
  public shared query ({caller}) func getWorkoutReports(typeOfExercise:Nat16): async Types.GetWorkoutReportsResponse{
    if(Principal.isAnonymous(caller)) {
      return {totalSetsPerExercise=0; totalRepsPerExercise=0; totalWorkouts=0; totalExercises=0};
    };

    // get user workouts
    let workouts = Map.get(state.map, phash, caller);

    var reps:Nat16 = 0;
    var sets:Nat16 = 0;
    var totalWorkouts:Nat = 0;
    var totalExercises:Nat = 0;
    switch (workouts) {
      case (null) {
        //Debug.print("Workout not found");
      };
      case (?w) {
        // loop over the exercies of a workout
        totalWorkouts := Map.size(w.workouts);
        for (workout in Map.vals(w.workouts)) {
          totalExercises := totalExercises + Iter.size(Iter.fromArray(workout.exercises));
          for (exercise in Iter.fromArray(workout.exercises)) {
            if (exercise.typeOfExercise == typeOfExercise) {
              sets := sets + 1;
              reps := reps + exercise.repetition;
              //Debug.print("Workout found");
            };
          };
        };
      };
    };
    {
      totalSetsPerExercise=sets;
      totalRepsPerExercise=reps;
      totalWorkouts=totalWorkouts;
      totalExercises=totalExercises;
    };
  };

  // collect all users for stats and/or profile
  public shared ({caller}) func createUserProfile(): async Bool {
    if(Principal.isAnonymous(caller)) {return false;};
    await User.createUserProfile(caller, state.users);
  };

  // get users feed
  public shared query ({caller}) func getUserFeed(): async [(Principal, Types.Feed)]{
    if(Principal.isAnonymous(caller)) {return []};

    // get users friends
    let friends = Map.get(state.users, phash, caller);
    //Debug.print("Friends: "#debug_show(friends));
    
    // get friends workouts
    var feed: Map.Map<Principal, Types.Feed> = Map.new<Principal, Types.Feed>();

    switch (friends) {
      case (?f) {
        for (friend in Map.keys(f.friends)){
          //Debug.print("Friend: "#Principal.toText(friend));
          // get alias from every friend
          let friendProfile = Map.get(state.users, phash, friend);
          
          let workouts = Map.get(state.map, phash, friend);
         
          switch (workouts) {
            case (?w) {
              let a = {
                alias = switch (friendProfile) {
                  case (?profile) profile.alias;
                  case (null) {
                    let a = Principal.toText(friend);
                    let b = Iter.toArray(Text.split(a, #char('-')));
                    b[0];
                  };
                };
                workouts = Map.toArray(w.workouts);
              };
              Map.set(feed, phash, friend, a);
            };
            case (null) {
              //Debug.print("No workouts found for friend");
            };
          };
        };
      };
      case (null) {
        //Debug.print("No friends found");
      };
    };

    // prepare the output for the users feed 
    let buffer = Buffer.Buffer<(Principal, Types.Feed)>(1);
    for ((key, value) in Map.entries(feed)) {
      buffer.add((key, {alias=value.alias; workouts = value.workouts}));
    };
    Buffer.toArray(buffer);  
  };

  // add friend to users profile
  public shared ({caller}) func addFriend(friend:Principal):async Bool {
    if(Principal.isAnonymous(caller)) {return false;};
    await User.addFriend(caller, friend, state.users);
  };

  // remove friend from users profile
  public shared ({caller}) func removeFriend(friend:Principal):async Bool {
    if(Principal.isAnonymous(caller)) {return false;};
    await User.removeFriend(caller, friend, state.users);
  };
  
  // update users profile data
  public shared ({caller}) func updateProfile(alias:Text):async Bool {
    if(Principal.isAnonymous(caller)) {
      return false;
    };
    await User.updateProfile(caller, alias, state.users);
  };

  // get users profile
  public shared query ({caller}) func getUserProfile(): async Types.GetUserProfileResponse {
    if(Principal.isAnonymous(caller)) {
      return {alias = ""; friends = []};
    };

    switch (Map.get(state.users, phash, caller)) {
      case (?u) {
        { alias = u.alias; friends = Iter.toArray(Map.keys(u.friends)) }
      };
      case (null) {
        { alias = ""; friends = [] }
      };
    }
  };  

  // get all users
  public shared query ({caller}) func getAllUsers(): async [(Principal,Text)] {
    if(Principal.isAnonymous(caller)) {return []};

    let buffer = Buffer.Buffer<(Principal, Text)>(1);
    for ((key, value) in Map.entries(state.users)) {
      buffer.add((key, value.alias));
    };
    Buffer.toArray(buffer);
  };
    
}
