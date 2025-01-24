import Types "../types";
import MigrationTypes "../migrations/types";

import Map "mo:map/Map";
import { phash } "mo:map/Map";
import { nhash } "mo:map/Map";

import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Debug "mo:base/Debug";

import Helper "helper";
import Workout "workout";

module {

  let StateTypes = MigrationTypes.Current;

  // update profile data
  public func updateProfile(caller:Principal, profile:Types.UpdateProfile, users: Map.Map<Principal, StateTypes.User>):async Bool {
    let user = Map.get(users, phash, caller);
    //Debug.print(debug_show(user));
    switch (user) {
      case (?u) {
        let updatedAlias = if (profile.alias == "") {
            Helper.getAliasFromPrincipal(caller)
          } else {
            profile.alias
          };

        let updatedUser:StateTypes.User = {
          alias = updatedAlias;
          size =  profile.size;
          friends = u.friends;
          points = u.points;
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
  public func removeFriend(caller:Principal, friend:Text, users: Map.Map<Principal, StateTypes.User>):async Bool {
    // Get the caller's friends
    let _friend = Principal.fromText(friend);
    switch (Map.get(users, phash, caller)) {
      case (?f) {
        if (Map.has(f.friends, phash, _friend)) {
          ignore Map.remove(f.friends, phash, _friend);
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
  public func addFriend(caller:Principal, friend:Text, users: Map.Map<Principal, StateTypes.User>):async Bool {
    // Get the caller's friends
    let _friend = Principal.fromText(friend);
    switch (Map.get(users, phash, caller)) {
      case (?f) {
        if (Map.has(f.friends, phash, _friend) == false) {
            Map.set(f.friends, phash, _friend, "");
            return true;
        } else {
            Debug.print("Friend already added");
            return false;
        }
      };
      case (null) {
        Debug.print("No userprofile found");
        return false;
      };
    }
  };

  // create user profile
  public func createUserProfile(caller:Principal, users: Map.Map<Principal, StateTypes.User> ): async Bool {
    if (Map.has(users, phash, caller) == false) {
      let user: StateTypes.User = {
        alias = Helper.getAliasFromPrincipal(caller);
        size = 0;
        friends = Map.new<Principal, Text>();
        points = 0;
      };
      Map.set(users, phash, caller, user);
      return true;
    };

    return false;
  };
  
  // get all users
  public func getAllUsers(users: Map.Map<Principal, StateTypes.User>, map:Map.Map<Principal,StateTypes.WorkoutToStore>): [Types.GetAllUsersResponse] {
    let buffer = Buffer.Buffer<(Types.GetAllUsersResponse)>(1);
    for ((key, value) in Map.entries(users)) {
      // find workouts for user
      let workouts = Map.get(map, phash, key);
      let totalWorkouts = switch (workouts) {
        case (?w) {
          Map.size(w.workouts);
        };
        case (null) {
          0;
        };
      };
      let _r = {
        principal= key;
        alias = value.alias;
        totalWorkouts = totalWorkouts;
        points = value.points;
      };
      buffer.add(_r);
    };
    Buffer.toArray(buffer);
  };

  // get all users
  public func getRanking(users: Map.Map<Principal, StateTypes.User>, map:Map.Map<Principal,StateTypes.WorkoutToStore>): [Types.GetRankingResponse] {
    let buffer = Buffer.Buffer<(Types.GetRankingResponse)>(1);
    for ((key, value) in Map.entries(users)) {
      // find workouts for user
      let workouts = Map.get(map, phash, key);
      let totalWorkouts = switch (workouts) {
        case (?w) {
          Map.size(w.workouts);
        };
        case (null) {
          0;
        };
      };
      let _r = {
        alias = value.alias;
        totalWorkouts = totalWorkouts;
        points = value.points;
      };
      buffer.add(_r);
    };
    Buffer.toArray(buffer);
  };

  // get users profile
  public func getUserProfile(
    caller:Principal, 
    users: Map.Map<Principal, StateTypes.User>,
    map: Map.Map<Principal, StateTypes.WorkoutToStore>
    ): Types.GetUserProfileResponse {
   
    switch (Map.get(users, phash, caller)) {
      case (?u) {
        // find principal and get size of workouts
        let totalWorkouts:Nat = switch (Map.get(map, phash, caller)) {
          case (?w) {
            Map.size(w.workouts);
          };
          case (null) {
            0;
          };
        };
        // get the alias to all friends and create a new friends response array
        let friends = Iter.toArray(Map.keys(u.friends));
       
        // get the alias to each friend
        let friendsAlias = Buffer.Buffer<(Types.Friend)>(1);

        for (friend in Iter.fromArray(friends)) {
          
          let workouts = Map.get(map, phash, friend);
          let totalWorkouts = switch (workouts) {
            case (?w) {
              Map.size(w.workouts);
            };
            case (null) {
              0;
            };
          };

          let optFriendProfile = Map.get(users, phash, friend);
          switch (optFriendProfile) {
            case (?profile) {
              friendsAlias.add({ principal=friend; alias=profile.alias; totalWorkouts=totalWorkouts; });
            };
            case (null) {
              friendsAlias.add({ principal=friend; alias=Helper.getAliasFromPrincipal(friend); totalWorkouts=totalWorkouts; });
            };
          };
        };  

        { alias = u.alias; size = u.size; friends = Buffer.toArray(friendsAlias); totalWorkouts = totalWorkouts; points = u.points };
      };
      case (null) {
        { alias=""; size=0; friends=[]; totalWorkouts=0; points=0 };
      };
    }
  }; 

  // get users feed
  public func getUserFeed(
    caller:Principal, 
    users: Map.Map<Principal, StateTypes.User>,
    map: Map.Map<Principal, StateTypes.WorkoutToStore>): [Types.GetUserFeedResponse] {

    // get users friends
    let friends = Map.get(users, phash, caller);
    //Debug.print("Friends: "#debug_show(friends));
    
    // get friends workouts
    var feed: Map.Map<Nat, Types.GetUserFeedResponse> = Map.new<Nat, Types.GetUserFeedResponse>();
    var counter = 0;
    switch (friends) {
      case (?f) {
        for (friend in Map.keys(f.friends)){
          //Debug.print("Friend: "#Principal.toText(friend));
          // get alias from every friend
          let friendProfile = Map.get(users, phash, friend);
          
          let workouts = Map.get(map, phash, friend);
          switch (workouts) {
            case (?w) {
              for ((key, value) in Map.entries(w.workouts)) {
                let wo = {
                  alias = switch (friendProfile) {
                    case (?profile) profile.alias;
                    case (null) {
                      Helper.getAliasFromPrincipal(friend);
                    };
                  };
                  date = value.date;
                  duration = value.duration;
                  exercises = value.exercises;
                };
                Map.set(feed, nhash, counter, wo);
                counter += 1;
              };
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
    let buffer = Buffer.Buffer<(Types.GetUserFeedResponse)>(1);
    for ((key, value) in Map.entries(feed)) {
      buffer.add({
        alias=value.alias; 
        date = value.date;
        duration = value.duration;
        exercises = value.exercises;
        });
    };
    Buffer.toArray(buffer);  
  }; 

  // remove a user with all workouts
  public func removeUser(caller:Principal, users: Map.Map<Principal, StateTypes.User>, map: Map.Map<Principal, StateTypes.WorkoutToStore>): Bool {
    if (Map.has(users, phash, caller)) {
      ignore Map.remove(users, phash, caller);
      ignore Map.remove(map, phash, caller);
      return true;
    };
    return false;
  };

  // get all user data in one call
  public func getAllUserData(user:Principal, users: Map.Map<Principal, StateTypes.User>, map: Map.Map<Principal, StateTypes.WorkoutToStore>): Types.GetAllUserDataResponse {
    
    // get userprofile
    let userProfile = getUserProfile(user, users, map);

    // get workouts
    let workouts = Workout.getWorkoutsPerPrincipal(user, map);

    // prepare output
    {
      principal=user;
      userProfile=userProfile;
      workouts=workouts;
    };
  };
};