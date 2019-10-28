import { u128 } from "bignum";

import {
  getScratchBuffer,
  getStorage,
  setRentAllowance,
  setScratchBuffer,
  setStorage,
  u32ToU8a
} from './lib';

const COUNTER_KEY: Uint8Array = new Uint8Array(32); // [1,1,1,1,1,1,1,1,1,...] in Rust impl, here [0,0,0,0,0,0,0,.....].
COUNTER_KEY.fill(1);

// Inc(648) => 0088020000 
// decimal: [0,136,2,0,0]
// Hex: 0x00000288

enum Action {
  Inc,
  Get,
  SelfEvict
}
// class Action with parameter value & method incBy

function handle(input: Uint8Array): Uint8Array { // vec<u8>
  const value : Uint8Array = new Uint8Array(0);
  const counter: Uint8Array = getStorage(COUNTER_KEY);
  const dataCounter: DataView = new DataView(counter.buffer);
  const counterValue: u32 = dataCounter.byteLength ? dataCounter.getUint32(0, true) : 0;

  // Get action from first byte of the input U8A
  switch (input[0]) {
    case Action.Inc:
      // read 4 bytes (u32) from storageBuffer with offset 1 
      const by: u32 = load<u32>(input.dataStart, 1);
      const newCounter: Uint8Array = u32ToU8a(counterValue + by);
      setStorage(COUNTER_KEY, newCounter)
      break;
    case Action.Get:
      // return the counter from storage
      if (counter.length)
        return counter;
      break;
    case Action.SelfEvict:
      const allowance = u128.from<u32>(0);
      setRentAllowance(allowance)
      break;
  }
  return value;
}

export function call(): u32 {
  // in ink min 4 bytes
  // input -> byte array
  // decode byte array to array/ enum Action (0,1,2,3) --> SCALE CODEC

  // scratch buffer filled with initial data
  const input: Uint8Array = getScratchBuffer();

  // @TODO: What'S the logic behind resetting scratchBuffer in handle()? Not happening in Get()
  const output: Uint8Array = handle(input);
  setScratchBuffer(output);
  return 0;
}

// deploy a new instance of the contract
export function deploy(): u32 {
  return 0
}
