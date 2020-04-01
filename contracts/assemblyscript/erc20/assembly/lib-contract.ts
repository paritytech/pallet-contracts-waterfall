/// <reference path="../node_modules/assemblyscript/std/assembly/index.d.ts" />

import {
  getStorage,
  hashSha256
} from './lib';

export function getBalanceOrZero(AccountId: Uint8Array): Uint8Array {
  const balance = getStorage(AccountId);
  return(balance.length === 16 ? balance : toBytes(0));
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

export function mergeToSha256(account1: Uint8Array, account2: Uint8Array): Uint8Array {
  const storageKey = new Uint8Array(account1.length + account2.length);
  storageKey.set(account1);
  storageKey.set(account2, account1.length);
 
  return(hashSha256(storageKey));
}