
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


export const getWeekNumberAndYear = (nsTimestamp:number) => {
  // Convert nanoseconds to milliseconds
  let msTimestamp = Math.floor(nsTimestamp / 1_000_000);
  let date = new Date(msTimestamp);
  
  // Extract the year
  let year = date.getUTCFullYear();

  // Find the first day of the year
  let firstDayOfYear = new Date(Date.UTC(year, 0, 1));

  // Get the day number of the year (0-based index)
  let dayOfYear = Math.floor((date.getTime() - firstDayOfYear.getTime()) / (1000 * 60 * 60 * 24)) + 1;

  // Compute week number (ISO 8601: weeks start on Monday)
  let weekNumber = Math.ceil((dayOfYear + firstDayOfYear.getUTCDay()) / 7);
  let weeekNummerFormat:string = ''+weekNumber;
  if(weekNumber < 10) {
    weeekNummerFormat = '0' + weekNumber;
  }

  //console.log('weekNumber: ',weeekNummerFormat);
  //console.log('year: ',year);

  return weeekNummerFormat + '/' + year;
}
