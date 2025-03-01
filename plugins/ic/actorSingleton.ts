import { idlFactory } from "../../src/declarations/backend/backend.did.js";
import { Actor, HttpAgent } from "@dfinity/agent";

import type { ActorSubclass } from "@dfinity/agent";
import type { _SERVICE } from "../../src/declarations/backend/backend.did";
import { useRuntimeConfig } from '#app';

// for typescript
declare global {
  interface Window {
    global: any;
  }
}
window.global ||= window;

type OptionsType = {
  agentOptions?: import("@dfinity/agent").HttpAgentOptions;
  actorOptions?: import("@dfinity/agent").ActorConfig;
};

let actorInstance: ActorSubclass<_SERVICE> | null = null;

export const getActor = async (options: OptionsType, clearActor: boolean): Promise<ActorSubclass<_SERVICE>> => {
  // to switch between login and logout
  let { $authClient } = useNuxtApp() as any;

  if (clearActor) {actorInstance = null;}

  if (!actorInstance) {

    //console.log('>> createActor as singleton pattern <<');
      
    const config = useRuntimeConfig();
    const canisterId = config.public.backendCanisterId;
    const network = config.public.network || 'local';
    const identity = await $authClient.getIdentity();
    /*
    if (identity) {
      console.log('Principal: ', identity.getPrincipal().toText());
    } else {
      console.log("Identity is undefined");
    }
    */

    let _host = 'http://localhost:4943';
    const hosts = ['ic', 'playground'];

    if (hosts.includes(network)) {
      _host = `https://${canisterId}.ic0.app`;
    }

    const hostOptions = { host: _host,  identity: identity};
    if (!options) {
      options = {
        agentOptions: hostOptions
      };
    } else if (!options.agentOptions) {
      options.agentOptions = hostOptions;
    } else {
      options.agentOptions.host = hostOptions.host;
    }
    
    const agent = HttpAgent.createSync({ ...options.agentOptions });

    // Fetch root key for certificate validation during development
    if (network !== "ic") {
      agent.fetchRootKey().catch((err) => {
        console.warn(
          "Unable to fetch root key. Check to ensure that your local replica is running"
        );
        console.error(err);
      });
    }

    actorInstance = Actor.createActor<_SERVICE>(idlFactory, {
      agent,
      canisterId: canisterId,
      ...options?.actorOptions,
    });
  }

  return actorInstance;
};