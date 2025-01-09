import { AuthClient } from "@dfinity/auth-client";

export const formatDate = (nanoseconds: number | bigint): string => {
  const milliseconds = Number(nanoseconds) / 1e6; // Convert nanoseconds to a Number
  const date = new Date(milliseconds);
  return date.toLocaleString();
};

export const replaceCount = (str: string, placeholder:string, count: number) => {
  return str.replace(placeholder, count.toString());
};

// split prinipalID to get the user name
export const splitPrincipalID = (principalID: string): string => {
  const parts = principalID.split('-');
  return parts[0];
};

export const formatNumber = (number: number) => {
  return new Intl.NumberFormat().format(number);
};

export const getIdentity = async () => {
  try {
    const authClient = await AuthClient.create();
    const identity = authClient.getIdentity();
    return identity;
  } catch (error) {
    console.error("Error getting identity:", error);
  }
};

export const isAuthenticated = async (): Promise<boolean> => {
  try {
    const identity = await getIdentity();
    return !identity?.getPrincipal().isAnonymous();
  } catch (error) {
    console.error("Error getting identity:", error);
  }
} 

