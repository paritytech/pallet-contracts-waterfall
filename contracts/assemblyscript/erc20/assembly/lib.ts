/// <reference path="../node_modules/assemblyscript/std/assembly/index.d.ts" />

import { u128 } from "as-bignum";
import {
  ext_balance,
  ext_caller,
  ext_get_storage,
  ext_println,
  ext_scratch_read,
  ext_scratch_size,
  ext_scratch_write,
  ext_set_rent_allowance,
  ext_set_storage,
  ext_value_transferred
} from "./env";

export enum StorageResult {
  Value,
  None
}

// This is just a wrapper function around the provided env host function 
export function getBalance(): Uint8Array {
  ext_balance();
  return getScratchBuffer();
}

export function getCaller(): Uint8Array {
  ext_caller();
  return getScratchBuffer();
}

export function getValueTransferred(): Uint8Array {
  ext_value_transferred();
  return getScratchBuffer();
}

export function printLine(value: string): void {
  const string = String.UTF8.encode(value);
  const stringArray = Uint8Array.wrap(string);
  ext_println(stringArray.dataStart, string.byteLength);
}


export function setStorage(key: Uint8Array, value: Uint8Array | null): void {
  if(key.length === 32) {
    const pointer = value ? value!.dataStart : 0;
    const length = value ? value.length : 0;
    const valueNonNull = i32(value !== null);
  
    ext_set_storage(key.dataStart, valueNonNull, pointer, length);
  }
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