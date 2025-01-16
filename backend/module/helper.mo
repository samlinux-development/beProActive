import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

module {
  
  public func getAliasFromPrincipal(principal:Principal):Text {
    let a = Principal.toText(principal);
    let b = Iter.toArray(Text.split(a, #char('-')));
    return b[0];
  };
}