import Debug "mo:base/Debug";
import Bool "mo:base/Bool";
import Principal "mo:base/Principal";
import Text "mo:base/Text";

import MigrationTypes "./migrations/types";
import Migrations "./migrations";
import Types "./types";

import Map "mo:map/Map";

import User "module/user";
import Workout "module/workout";

shared ({ caller = creator }) actor class Main () {
  
  let StateTypes = MigrationTypes.Current;

  // you will have only one stable variable
  // move all your stable variable declarations to "migrations/001-initial/types.mo -> State"
  stable var migrationState: MigrationTypes.State = #v0_0_0(#data);

  // do not forget to change #v0_1_0 when you are adding a new migration
  // if you use one of previus states in place of #v0_1_0 it will run downgrade methods instead
  migrationState := Migrations.migrate(migrationState, #v0_1_1(#id), { creator });

  // do not forget to change #v0_1_0 when you are adding a new migration
  let state = switch (migrationState) { case (#v0_1_1(#data(state))) state; case (_) Debug.trap("Unexpected migration state") };

  //----------------------------------
  // public methods
  //----------------------------------
  // get latest workouts
  public shared query func getLatestWorkouts(): async [(Nat, StateTypes.LatestWorkouts)]{
    Workout.getLatestWorkouts(state.latestWorkouts);
  };

  // get all public reports
  public query func getPublicReports(): async Types.GetPublicReportsResponse{
    let users = Map.size(state.users);

    {
      totalUsers = users;
    }
  };

  // getRanking
  public query func getRanking(): async [Types.GetRankingResponse]{
    User.getRanking(state.users, state.map);
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

  // get maxPublicWorkouts limit for latest workouts
  public shared query ({caller}) func getMaxPublicWorkouts() : async Nat {
    // Only the creator can get the limit
    if (caller != creator) {
        return 0;
    };
    state.maxPublicWorkouts;
  };

  // get currentÜublicWorkoutId 
  public shared query ({caller}) func getCurrentPublicWorkoutId() : async Nat {
    // Only the creator can get the limit
    if (caller != creator) {
        return 0;
    };
    state.currentPublicWorkoutId;
  };
  
  // get all workouts
  public shared query ({caller}) func getAllWorkouts(): async [(Principal, {workouts: [(Nat, StateTypes.Workout)]})]{
    if (caller != creator) {return [];};
    Workout.getAllWorkouts(state.map);
  };

  // get all user data
  public shared query ({caller}) func getAllUserData(user:Principal): async ?Types.GetAllUserDataResponse {
    if (caller != creator) {return null;};
    ?User.getAllUserData(user, state.users, state.map);  
  };

  // remove a user from the system
  public shared ({caller}) func removeUser(user: Principal): async Bool {
    if (caller != creator) {return false;};
    User.removeUser(user, state.users, state.map);
  };

  // update users points (in case of emergency)
  public shared ({caller}) func updatePoints(user: Principal, points: Nat): async Nat{
    if (caller != creator) {return 0;};
    User.updatePoints(user, points, state.users);
  };

  //----------------------------------
  // only for authenticate users
  //----------------------------------
  // add a new workout to the user's workout map
  public shared ({caller}) func addWorkout(workout: StateTypes.WorkoutPayload) : async Bool{
    if(Principal.isAnonymous(caller)) {return false;};
    state.currentPublicWorkoutId := state.currentPublicWorkoutId + 1;
    await Workout.addWorkout(
      caller, 
      workout, 
      state.map, 
      state.latestWorkouts, 
      state.users, 
      state.maxPublicWorkouts,
      state.currentPublicWorkoutId
      );
  };

  // get all workouts per principal
  public shared query ({caller}) func getWorkoutsPerPrincipal(): async [Types.WorkoutsPerUserResponse]{
    if(Principal.isAnonymous(caller)) {return []};
    Workout.getWorkoutsPerPrincipal(caller, state.map);
  };

  // get workout reports for principal
  public shared query ({caller}) func getWorkoutReports(typeOfExercise:Nat16): async Types.GetWorkoutReportsResponse{
    if(Principal.isAnonymous(caller)) {
      return {totalSetsPerExercise=0; totalRepsPerExercise=0; totalWorkouts=0; totalExercises=0};
    };

    Workout.getWorkoutReports(caller, typeOfExercise, state.map);
  };

  // collect all users for stats and/or profile
  public shared ({caller}) func createUserProfile(): async Bool {
    if(Principal.isAnonymous(caller)) {return false;};
    await User.createUserProfile(caller, state.users);
  };

  // get users feed
  public shared query ({caller}) func getUserFeed(): async [Types.GetUserFeedResponse]{
    if(Principal.isAnonymous(caller)) {return []};
    User.getUserFeed(caller, state.users, state.map);
  };

  // add friend to users profile
  public shared ({caller}) func addFriend(friend:Text):async Bool {
    if(Principal.isAnonymous(caller)) {return false;};
    await User.addFriend(caller, friend, state.users);
  };

  // remove friend from users profile
  public shared ({caller}) func removeFriend(friend:Text):async Bool {
    if(Principal.isAnonymous(caller)) {return false;};
    await User.removeFriend(caller, friend, state.users);
  };
  
  // update users profile data
  public shared ({caller}) func updateProfile(profile:Types.UpdateProfile):async Bool {
    if(Principal.isAnonymous(caller)) {
      return false;
    };
    await User.updateProfile(caller, profile, state.users);
  };

  // get users profile
  public shared query ({caller}) func getUserProfile(): async Types.GetUserProfileResponse {
    if(Principal.isAnonymous(caller)) {
      return {alias = ""; size=0; friends = []; totalWorkouts = 0; points = 0};
    };

    User.getUserProfile(caller, state.users, state.map);
  };  

  // get all users
  public shared query ({caller}) func getAllUsers(): async [Types.GetAllUsersResponse] {
    if(Principal.isAnonymous(caller)) {return []};
    User.getAllUsers(state.users, state.map);
  };

  // remove a given workout by user
  public shared ({caller}) func removeWorkout(workoutId: Nat): async Bool {
    if(Principal.isAnonymous(caller)) {return false;};
    Workout.removeWorkout(caller, workoutId, state.map, state.users);
  };

}
