import MigrationTypes "../types";

import Map "mo:map/Map";
import V0_1_0 "./types";
module {
  public func upgrade(_prevMigrationState: MigrationTypes.State, _args: MigrationTypes.Args): MigrationTypes.State {
    return #v0_1_0(#data({
      // initailize your state here
      var maxPublicWorkouts: Nat = 1;
      var map = Map.new<Principal, V0_1_0.WorkoutToStore>();
      var users = Map.new<Principal, V0_1_0.User>();
      var latestWorkouts = Map.new<Nat, V0_1_0.LatestWorkouts>();
      
    }));
  };
};