import MigrationTypes "../types";

import Map "mo:map/Map";
import V0_1_0 "./types";
module {
  public func upgrade(_prevMigrationState: MigrationTypes.State, _args: MigrationTypes.Args): MigrationTypes.State {
    return #v0_1_0(#data({
      // initailize your state here
      var counter:V0_1_0.Counter = 1;
      var maxPublicWorkouts: Nat = 1;
      var map = Map.new<Nat, V0_1_0.Workout>();
      var users = Map.new<Principal, V0_1_0.User>();
      
    }));
  };
};