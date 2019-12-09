/// <reference path="../node_modules/assemblyscript/std/assembly/index.d.ts" />

import {
  getStorage
} from './lib';

export function getBalanceOrZero(AccountId: Uint8Array): Uint8Array {
  const balance = getStorage(AccountId).subarray(0,16);
  return(balance.length ? balance : toBytes(0));
}


export function toBytes<T>(num: T, le: boolean = true): Uint8Array {
  // accept only integers and booleans
  if (isInteger<T>()) {
    const arr = new Uint8Array(sizeof<T>());
    store<T>(arr.dataStart, le ? num : bswap(num));
    return arr;
  }
  assert(false);
}