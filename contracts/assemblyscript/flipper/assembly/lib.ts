/// <reference path="../node_modules/assemblyscript/std/assembly/index.d.ts" />

import { u128 } from "as-bignum";
import {
  ext_clear_storage,
  ext_get_storage,
  ext_scratch_read,
  ext_scratch_size,
  ext_scratch_write,
  ext_set_rent_allowance,
  ext_set_storage
} from "./env";

export enum StorageResult {
  Value,
  None
}

// @ts-ignore: no-return
export function toBytes<T>(num: T, le: boolean = true): Uint8Array {
  // accept only integers and booleans
  if (isInteger<T>()) {
    const arr = new Uint8Array(sizeof<T>());
    store<T>(arr.dataStart, le ? num : bswap(num));
    return arr;
  }
  assert(false);
}

export function clearStorage(key: Uint8Array): void {
  ext_clear_storage(key.dataStart);
}

export function setStorage(key: Uint8Array, value: Uint8Array | null): void {
  const pointer = value ? value!.dataStart : 0;
  const length = value ? value.length : 0;

  ext_set_storage(key.dataStart, pointer, length);
}

// check for length 32 bytes
export function getStorage(key: Uint8Array): Uint8Array {
  const result = ext_get_storage(key.dataStart);
  let value = new Uint8Array(0);

  // if value is found
  if (result === StorageResult.Value) {
    // // getting size of scratch buffer to allocate the buffer of corresponding size to fit the contents of the scratch buffer
    const size = ext_scratch_size();
    // if value is not null or not an empty array
    if (size > 0) {
      // create empty array (Vec in Rust)
      value = new Uint8Array(size);
      // call
      ext_scratch_read(value.dataStart, 0, size);
    }
  }
  return value;
}

export function getScratchBuffer(): Uint8Array {
  let value = new Uint8Array(0);
  // Returns the size of the scratch buffer.
  const size = ext_scratch_size();

  if (size > 0) {
    value = new Uint8Array(size);
    // copy data from scratch buffer
    ext_scratch_read(value.dataStart, 0, size);
  }
  return value;
}

export function setScratchBuffer(data: Uint8Array): void {
  ext_scratch_write(data.dataStart, data.length);
}

export function setRentAllowance(value: u128): void {
  const valueBuffer = value.toUint8Array();
  ext_set_rent_allowance(valueBuffer.dataStart, valueBuffer.length);
}
