import { u128 } from "bignum";

import {
  getScratchBuffer,
  getStorage,
  setRentAllowance,
  setScratchBuffer,
  setStorage,
  toBytes
} from "./lib";

const COUNTER_KEY = (new Uint8Array(32) as Uint8Array).fill(1); // [1,1,1, ... 1]

// Inc(648) => 0088020000
// decimal: [0,136,2,0,0]
// Hex: 0x00000288

enum Action {
  Inc,
  Get,
  SelfEvict
}
// class Action with parameter value & method incBy

function handle(input: Uint8Array): Uint8Array {
  // vec<u8>
  const value = new Uint8Array(0);
  const counter = getStorage(COUNTER_KEY);

  const dataCounter = new DataView(counter.buffer);
  const counterValue: u32 = dataCounter.byteLength
    ? dataCounter.getUint32(0, true)
    : 0;

  // Get action from first byte of the input U8A
  switch (input[0]) {
    case Action.Inc:
      // read 4 bytes (u32) from storageBuffer with offset 1
      const by = load<u32>(input.dataStart, 1);
      const newCounter = toBytes(counterValue + by);
      setStorage(COUNTER_KEY, newCounter);
      break;
    case Action.Get:
      // return the counter from storage
      if (counter.length) return counter;
      break;
    case Action.SelfEvict:
      const allowance = u128.from<u32>(0);
      setRentAllowance(allowance);
      break;
  }
  return value;
}

export function call(): u32 {
  // in ink min 4 bytes
  // input -> byte array
  // decode byte array to array/ enum Action (0,1,2,3) --> SCALE CODEC

  // scratch buffer filled with initial data
  const input = getScratchBuffer();

  const output = handle(input);
  setScratchBuffer(output);
  return 0;
}

// deploy a new instance of the contract
export function deploy(): u32 {
  return 0;
}
