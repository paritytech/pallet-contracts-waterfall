/// <reference path="../node_modules/assemblyscript/std/assembly/index.d.ts" />

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

export function mergeToSha256(U8A1: Uint8Array, U8A2: Uint8Array): Uint8Array {
  // Merging TypedArrays is not implemented in AssemblyScript yet.
  // That's why we need to read directly from memory
  // See https://stackoverflow.com/questions/59270312/concatenate-or-merge-typedarrays-in-assemblyscript
  // Also this PR https://github.com/AssemblyScript/assemblyscript/pull/1002
  
  const storageKeyApprove = new Uint8Array(64);
  const fromPtr = from.dataStart;
  const toPtr = to.dataStart;
  const keyPtr = storageKeyApprove.dataStart;
  memory.copy(keyPtr, fromPtr, 32);
  memory.copy(keyPtr + 32, toPtr, 32);

  return storageKeyApprove
}