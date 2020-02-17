import { u128 } from "as-bignum";

import {
  getScratchBuffer,
  getStorage,
  setRentAllowance,
  setScratchBuffer,
  setStorage,
  toBytes
} from "./lib";

// This simple dummy contract has a `bool` value that can
// alter between `true` and `false` using the `flip` message.

const FLIPPER_KEY = (new Uint8Array(32)).fill(2); // [2,2,2, ... 2]

enum Action {
  Flip,
  Get,
  SelfEvict
}

function handle(input: Uint8Array): Uint8Array {
  // vec<u8>
  const value = new Uint8Array(0);
  const flipper = getStorage(FLIPPER_KEY);
  const dataFlipper = new DataView(flipper.buffer);
  const flipperValue = dataFlipper.byteLength ? dataFlipper.getUint8(0) : 0;

  // Get action from first byte of the input U8A
  switch (input[0]) {
    case Action.Flip:
      const newFlipperBool = !flipperValue;
      const newFlipperValue = toBytes(newFlipperBool);

      setStorage(FLIPPER_KEY, newFlipperValue);
      break;
    case Action.Get:
      // return the flipper value from storage
      if (flipper.length) return flipper;
      break;
    case Action.SelfEvict:
      const allowance = u128.from<u32>(0);
      setRentAllowance(allowance);
      break;
  }
  return value;
}

export function call(): u32 {
  const input = getScratchBuffer();
  const output = handle(input);

  setScratchBuffer(output);
  return 0;
}

// deploy a new instance of the contract with the default value 0x00 (false)
export function deploy(): u32 {
  const newFlipper = toBytes(false);
  setStorage(FLIPPER_KEY, newFlipper);
  return 0;
}
