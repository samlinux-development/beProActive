
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
  let { $authClient } = useNuxtApp() as any;
  try {
    const identity = $authClient.getIdentity();
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
    return false;
  }
} 

export const formatDuration = (milliseconds: bigint) => {
  const seconds = Math.floor(Number(milliseconds) / 1000);
  const hours = Math.floor(seconds / 3600);
  const minutes = Math.floor((seconds % 3600) / 60);
  const remainingSeconds = seconds % 60;
  // output format is hh:mm:ss print only values are available
  //console.log(hours, minutes, remainingSeconds);
  
  let formatTime = '';
  if (hours > 0) {
    formatTime += `${hours}h `;
  }

  if (minutes > 0) {
    formatTime += `${minutes}m `;
  }

  if (remainingSeconds > 0) {
    formatTime += `${remainingSeconds}s`;
  }

  return formatTime.trim();
};

