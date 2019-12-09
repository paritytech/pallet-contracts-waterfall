/// <reference path="../node_modules/assemblyscript/std/assembly/index.d.ts" />

import { u256, u128 } from "bignum";

import {
  getStorage,
  toBytes
} from './lib';

export function getBalanceOrZero(AccountId: Uint8Array): Uint8Array {
  const balance = getStorage(AccountId).subarray(0,16);
  return(balance.length ? balance : toBytes(0));
}

export function add<T>(a: T, b: T): T {
  if (isString<T>()) { // eliminated if T is not a string
    return parseInt(a) + parseInt(b)
  } else { // eliminated if T is a string
    return a + b
  }
}