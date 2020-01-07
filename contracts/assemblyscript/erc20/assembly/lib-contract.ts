/// <reference path="../node_modules/assemblyscript/std/assembly/index.d.ts" />

import { hash } from "../node_modules/@chainsafe/as-sha256/assembly";

import {
  getStorage
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
  // Merging TypedArrays is not implemented in AssemblyScript yet.
  // That's why we need to read directly from memory
  // See https://stackoverflow.com/questions/59270312/concatenate-or-merge-typedarrays-in-assemblyscript
  // Also this PR https://github.com/AssemblyScript/assemblyscript/pull/1002
  
  const storageKey = new Uint8Array(64);
  const account1Ptr = account1.dataStart;
  const account2Ptr = account2.dataStart;
  const keyPtr = storageKey.dataStart;
  memory.copy(keyPtr, account1Ptr, 32);
  memory.copy(keyPtr + 32, account2Ptr, 32);
  return(hash(storageKey));
}