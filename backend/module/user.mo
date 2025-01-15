import V0_1_0 "../migrations/00-01-00-initial/types";
import MigrationTypes "../migrations/types";
import Map "mo:map/Map";
import { phash } "mo:map/Map";

module {

  let StateTypes = MigrationTypes.Current;

  // update profile data
  public func updateProfile(caller:Principal, alias:Text, users: Map.Map<Principal, V0_1_0.User>):async Bool {
    let user = Map.get(users, phash, caller);
    switch (user) {
      case (?u) {
        let updatedUser:StateTypes.User = {
          alias = alias;
          friends = u.friends;
        };
        Map.set(users, phash, caller, updatedUser);
        true;
      };
      case (null) {
        false;
      };
    };
  };

  // remove friend
  public func removeFriend(caller:Principal, friend:Principal, users: Map.Map<Principal, V0_1_0.User>):async Bool {
    // Get the caller's friends
    switch (Map.get(users, phash, caller)) {
      case (?f) {
        if (Map.has(f.friends, phash, friend)) {
          ignore Map.remove(f.friends, phash, friend);
          return true;
        } else {
          return false;
        }
      };
      case (null) {
        return false;
      };
    }
  };

  // add friend
  public func addFriend(caller:Principal, friend:Principal, users: Map.Map<Principal, V0_1_0.User>):async Bool {
    // Get the caller's friends
    switch (Map.get(users, phash, caller)) {
      case (?f) {
        if (Map.has(f.friends, phash, friend) == false) {
            Map.set(f.friends, phash, friend, "");
            return true;
        } else {
            return false;
        }
      };
      case (null) {
        return false;
      };
    }
  };

  // create user profile
  public func createUserProfile(caller:Principal, users: Map.Map<Principal, V0_1_0.User> ): async Bool {
    if (Map.has(users, phash, caller) == false) {
      let user: StateTypes.User = {
        alias = "";
        friends = Map.new<Principal, Text>();
      };
      Map.set(users, phash, caller, user);
      return true;
    };

    return false;
  };
  
};