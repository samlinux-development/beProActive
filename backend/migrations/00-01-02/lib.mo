import Debug "mo:base/Debug";
import Map "mo:map/Map";

import MigrationTypes "../types";
import V0_1_2 "./types";

module {
  public func upgrade(migrationState: MigrationTypes.State, _args: MigrationTypes.Args): MigrationTypes.State {
    // access previous state
    let state = switch (migrationState) { case (#v0_1_1(#data(state))) state; case (_) Debug.trap("Unexpected migration state") };
    
    return #v0_1_2(#data({
      // initailize your state here
      var currentPublicWorkoutId = state.currentPublicWorkoutId;
      var maxPublicWorkouts = state.maxPublicWorkouts;
      var map = state.map;
      var users = state.users;
      var latestWorkouts = state.latestWorkouts;
      var stats = Map.new<Principal, V0_1_2.StatsPerUser>();
      
    }));
  };
};