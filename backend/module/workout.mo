import MigrationTypes "../migrations/types";
import Types "../types";

import Map "mo:map/Map";
import { phash } "mo:map/Map";
import { nhash } "mo:map/Map";
import { ihash } "mo:map/Map";

import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Nat16 "mo:base/Nat16";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import Int "mo:base/Int";


import Helper "helper";

module {
 
  let StateTypes = MigrationTypes.Current;

  // add a new workout to the user's workout map
  // ranking rules:
  // 10 points per Workout
  // 10 points per adding a friend
  // -10 points per removing a friend
  // 1 point per exercise
  // 1 point per each repetition

  public func addWorkout(
    caller:Principal, 
    workout: StateTypes.WorkoutPayload, 
    map: Map.Map<Principal, StateTypes.WorkoutToStore>,
    latestWorkout: Map.Map<Nat, StateTypes.LatestWorkouts>,
    users: Map.Map<Principal, StateTypes.User>,
    stats: Map.Map<Principal, StateTypes.StatsPerUser>,
    maxPublicWorkouts:Nat,
    currentPublicWorkoutId:Nat) : async Bool {

    if (Map.contains(map, phash, caller) == ?true){
      let wOpt = Map.get(map, phash, caller);
      switch (wOpt) {
        case (?w) {
          // add new workout to existing map

          let newWorkout:StateTypes.Workout = {
            date = Time.now();
            duration = workout.duration;
            exercises = workout.exercises;
          };

          let newWorkoutCount:Nat = Map.size(w.workouts)+1;
          //Debug.print("Size "#debug_show(newWorkoutCount));
          Map.set(w.workouts, nhash, newWorkoutCount, newWorkout);

          // add latest workout
          let _r = addLatestWorkout(caller, newWorkout, latestWorkout, users, currentPublicWorkoutId, maxPublicWorkouts);

          // add the points to the user
          let _r2 = addPoints(caller, newWorkout, users);

          // add workout stats to weekly user stats
          let _r3 = addWorkoutStats(caller, workout, stats);

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
      let _r = addLatestWorkout(caller, newWorkout, latestWorkout, users, currentPublicWorkoutId, maxPublicWorkouts);

      // add the points to the user
      let _r2 = addPoints(caller, newWorkout, users);
      
      // add workout stats to weekly user stats
      let _r3 = addWorkoutStats(caller, workout, stats);
      
      //Debug.print("First Workout added");
      return true;
    }
  };
  
  // add workout stats to weekls users stats
  public func addWorkoutStats(
    caller: Principal, 
    workout: StateTypes.WorkoutPayload, 
    stats: Map.Map<Principal, StateTypes.StatsPerUser>
  ): Bool {
    
    let week = Helper.normalizeToWeekStart(Time.now());
    
    switch (Map.get(stats, phash, caller)) {
      case (?w) {
        // If user exists, get weekly stats
        switch (Map.get(w.weekStats, ihash, week)) {
          case (?ws) {
            // Update existing weekly stats
            let newWeeklyStats: StateTypes.WeeklyStats = {
              totalWorkouts = ws.totalWorkouts + 1;
              totalDuration = ws.totalDuration + workout.duration;
            };
            Map.set(w.weekStats, ihash, week, newWeeklyStats);
          };
          case null {
            // Create new weekly stats for the current week
            let newWeeklyStats: StateTypes.WeeklyStats = {
              totalWorkouts = 1;
              totalDuration = workout.duration;
            };
            Map.set(w.weekStats, ihash, week, newWeeklyStats);
          };
        };
      };
      case null {
        // If user does not exist, create new user stats
        let newWeeklyStats: StateTypes.WeeklyStats = {
          totalWorkouts = 1;
          totalDuration = workout.duration;
        };
        let newStats: StateTypes.StatsPerUser = {
          weekStats = Map.new<Int, StateTypes.WeeklyStats>(); // Ensure proper typing
        };
        Map.set(newStats.weekStats, ihash, week, newWeeklyStats);
        Map.set(stats, phash, caller, newStats);
      };
    };
    
    return true;
  };

  // add points to a user
  func addPoints(caller:Principal, newWorkout:StateTypes.Workout, users: Map.Map<Principal, StateTypes.User>): Bool{
   
    let user = Map.get(users, phash, caller);
    switch (user) {
      case (?u) {
        let points = calcPoints(newWorkout);
        let newPoints = u.points + points;
        let newUser:StateTypes.User = {
          alias = u.alias;
          size = u.size;
          friends = u.friends;
          points = newPoints;
        };
        Map.set(users, phash, caller, newUser);
        return true;
      };
      case (null) {
        return false;
      };
    };
  };

  // remove points from a user
  func removePoints(caller:Principal, workout:StateTypes.Workout, users: Map.Map<Principal, StateTypes.User>): Bool{
    let user = Map.get(users, phash, caller);
    switch (user) {
      case (?u) {
        let points = calcPoints(workout);
        if(points > u.points) {
          return false;
        };
        //Debug.print("Points "#debug_show(points));
        //Debug.print("u.points "#debug_show(u.points));
        let newPoints = Nat.sub(u.points, points);

        let newUser:StateTypes.User = {
          alias = u.alias;
          size = u.size;
          friends = u.friends;
          points = newPoints;
        };
        
        Map.set(users, phash, caller, newUser);
        return true;
      };
      case (null) {
        return false;
      };
    };
  };

  // calculate points for a workout for a user
  func calcPoints(workout:StateTypes.Workout):Nat{
    // Base points = 10
    var totalPoints = 10;

    // Add 1 point per exercise
    totalPoints += Array.size(workout.exercises);

    // Add 1 point per repetition
    for (exercise in Iter.fromArray(workout.exercises)) {
      totalPoints += Nat16.toNat(exercise.set);
    };

    //Debug.print("workout "#debug_show(workout));
    //Debug.print("totalPoints "#debug_show(totalPoints));
    totalPoints;
  };

  // and latest workout and removes the oldest if the max size is reached
  // this is a capped map for the public view
  func addLatestWorkout(
    caller:Principal, 
    workout: StateTypes.Workout, 
    latestWorkout: Map.Map<Nat, StateTypes.LatestWorkouts>,
    users: Map.Map<Principal, StateTypes.User>,
    currentPublicWorkoutId:Nat,
    maxPublicWorkouts:Nat) : Bool{
    
    let alias = getAlias(caller, users);
    let newWorkout:StateTypes.LatestWorkouts = {
      alias = alias;
      date = workout.date;
      exercises = workout.exercises;
    };

    Map.set(latestWorkout, nhash, currentPublicWorkoutId, newWorkout);
  
    //Debug.print("workout added to latestWorkouts "#debug_show(newWorkout));
    //Debug.print("new workout count "#debug_show(currentPublicWorkoutId));
    let sizeOfLatestWorkouts = Map.size(latestWorkout);

    // Remove the oldest workouts if the max size is reached
    if (sizeOfLatestWorkouts > maxPublicWorkouts) {
      let keys = Iter.toArray(Map.keys(latestWorkout));
      //Debug.print("Keys "#debug_show(keys));
      let sortedKeys = Array.sort<Nat>(keys, func (a, b) {
        if (a < b) {
          #less
        } else if (a > b) {
          #greater
        } else {
          #equal
        }
      });

      let excessCount:Nat = sizeOfLatestWorkouts - maxPublicWorkouts - 1 ;
      //Debug.print("excessCount "#debug_show(excessCount));
      for (i in Iter.range(0, excessCount)) {
        let oldest = sortedKeys[i];
        //Debug.print("Removing oldest workout "#debug_show(oldest));
        ignore Map.remove(latestWorkout, nhash, oldest);
      };
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

  // get workout reports for principal
  public func getWorkoutReports(
    caller:Principal, 
    typeOfExercise:Nat16, 
    map: Map.Map<Principal, StateTypes.WorkoutToStore>): Types.GetWorkoutReportsResponse{
    if(Principal.isAnonymous(caller)) {
      return {totalSetsPerExercise=0; totalRepsPerExercise=0; totalWorkouts=0; totalExercises=0};
    };

    // get user workouts
    let workouts = Map.get(map, phash, caller);

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

  // get all workouts per principal
  public func getWorkoutsPerPrincipal(caller:Principal, map: Map.Map<Principal, StateTypes.WorkoutToStore>): [Types.WorkoutsPerUserResponse]{

    let buffer = Buffer.Buffer<(Types.WorkoutsPerUserResponse)>(1);
    if (Map.contains(map, phash, caller) == ?true){
      let wOpt = Map.get(map, phash, caller);
      switch (wOpt) {
        case (?w) {
          // I need to loop over the workouts and return them with the id as key
          for ((key, value) in Map.entries(w.workouts)) {
            buffer.add({
              id = key;
              date = value.date;
              duration = value.duration;
              exercises = value.exercises;
            });
          };        
        };
        case (null) {
          //Debug.print("Workout not found");
        };
      };
     };
    Buffer.toArray(buffer);
  };

  // get all workouts
  public func getAllWorkouts(map: Map.Map<Principal, StateTypes.WorkoutToStore>): [(Principal, {workouts: [(Nat, StateTypes.Workout)]})]{
    let buffer = Buffer.Buffer<(Principal, {workouts: [(Nat, StateTypes.Workout)]})>(1);
    for ((key, value) in Map.entries(map)) {
      let workoutsArray = Map.toArray(value.workouts);
      buffer.add((key, {workouts = workoutsArray}));
    };
    Buffer.toArray(buffer);
  };

  // get latest workouts
  public func getLatestWorkouts(latestWorkouts:Map.Map<Nat,StateTypes.LatestWorkouts>): [(Nat, StateTypes.LatestWorkouts)]{
    let buffer = Buffer.Buffer<(Nat,StateTypes.LatestWorkouts)>(1);
    for ((key, value) in Map.entries(latestWorkouts)) {
      buffer.add((key,value));
    };
    Buffer.toArray(buffer);
  };

  // remove a given workout by user
  public func removeWorkout(
    caller:Principal, 
    workoutId:Nat, 
    map: Map.Map<Principal, StateTypes.WorkoutToStore>,
    users: Map.Map<Principal, StateTypes.User>
    ): Bool{
    if (Map.contains(map, phash, caller) == ?true){
      let wOpt = Map.get(map, phash, caller);
      switch (wOpt) {
        case (?w) {
          
          if (Map.contains(w.workouts, nhash, workoutId) == ?true) {
            // ------------------------------
            // remove the points to the user from the workout with the workoutId
            // ------------------------------
            let workout = Map.get(w.workouts, nhash, workoutId);
            switch (workout) {
              case (?w) {
                let _r = removePoints(caller, w, users);
              };
              case (null) {
                //Debug.print("Workout not found");
              };
            };

            // ------------------------------
            // remove the workout from the user
            // ------------------------------
            ignore Map.remove(w.workouts, nhash, workoutId);
            
            return true;
          };
        };
        case (null) {
          //Debug.print("Workout not found");
          return false;
        };
      };
    };
    return false;
  };

  // get all workouts from the current week for a given user
  public func getWorkoutsPerRangeReport(
    caller:Principal, 
    firstDayReport:Int,
    lastDayReport:Int,
    map: Map.Map<Principal, StateTypes.WorkoutToStore>): Types.WorkoutsPerRangeResponse{
    
    var totalDuration:Int=0;
    var totalCount:Int=0;

    switch (Map.get(map, phash, caller)) {
      case (?w) {
        let workouts = Map.vals(w.workouts);
        
        for (workout in workouts) {
          if (workout.date >= firstDayReport and workout.date <= lastDayReport) {
            totalDuration := totalDuration + workout.duration;
            totalCount := totalCount + 1;
          };
        };
      };
      case (null) {
        Debug.print("Workout not found");
      };
    };
    
    {
      totalCount = totalCount;
      totalDuration = totalDuration;
    };

  };
}