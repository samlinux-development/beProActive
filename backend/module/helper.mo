import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

module {
  
  public func getAliasFromPrincipal(principal:Principal):Text {
    let a = Principal.toText(principal);
    let b = Iter.toArray(Text.split(a, #char('-')));
    return b[0];
  };

  // Nanoseconds in a day
  let oneDay: Int = 86_400_000_000_000; 

  // 1970-01-01 was a Thursday (Motoko uses 0 = Monday)
  let unixEpochWeekday: Int = 3; 

  /// Returns the timestamp of Monday 00:00:00 UTC of the given time's week
   public func normalizeToWeekStart(timestamp: Int): Int {
      let daysSinceEpoch: Int = timestamp / oneDay;
      
      // Calculate weekday (ensuring 0 = Monday)
      let weekday: Int = (daysSinceEpoch + unixEpochWeekday) % 7; 
      
      // Calculate how many days to subtract to reach the previous Monday
      let daysToSubtract: Int = if (weekday == 0) 0 else weekday; 
      
      let mondayTimestamp: Int = timestamp - (daysToSubtract * oneDay);

      // Normalize to 00:00:00 UTC of Monday
      mondayTimestamp - (mondayTimestamp % oneDay)
  };

}