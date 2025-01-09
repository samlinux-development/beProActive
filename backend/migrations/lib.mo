import V0_1_0 "./00-01-00-initial";
import MigrationTypes "./types";

module {
  let upgrades = [
    V0_1_0.upgrade
    // do not forget to add your new migration upgrade method here
  ];


  func getMigrationId(state: MigrationTypes.State): Nat {
    return switch (state) {
      case (#v0_0_0(_)) 0;
      case (#v0_1_0(_)) 1;
      // do not forget to add your new migration id here
      // should be increased by 1 as it will be later used as an index to get upgrade/downgrade methods
    };
  };

  // only upgrades are needed for now, no downgrades
  public func migrate(prevState: MigrationTypes.State, nextState: MigrationTypes.State, args: MigrationTypes.Args): MigrationTypes.State {
    var state = prevState;
    var migrationId = getMigrationId(prevState);

    let nextMigrationId = getMigrationId(nextState);

    while (migrationId != nextMigrationId) {
      let migrate = upgrades[migrationId];

      migrationId := migrationId + 1;

      state := migrate(state, args);
    };

    return state;
  };
};