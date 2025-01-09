import Migration001 "./00-01-00-initial/types";

module {
  // do not forget to change current migration when you add a new one
  // you should use this field to import types from you current migration anywhere in your project
  // instead of importing it from migration folder itself
  public let Current = Migration001;

  public type Args = {
    creator: Principal;
    // you can add any fields here to pass external data to your migrations
  };

  public type State = {
    #v0_0_0: { #id; #data: () };
    #v0_1_0: { #id; #data: Migration001.State };
    // do not forget to add your new migration state types here
  };
};