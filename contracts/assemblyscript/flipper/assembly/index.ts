import { u128 } from "bignum";

import {
  getScratchBuffer,
  getStorage,
  setRentAllowance,
  setScratchBuffer,
  setStorage
} from './lib';

import {
  u32ToU8a
} from './../../incrementer/assembly/lib';


// This simple dummy contract has a `bool` value that can
// alter between `true` and `false` using the `flip` message.

const FLIPPER_KEY: Uint8Array = new Uint8Array(32);
FLIPPER_KEY.fill(2);

enum Action {
  Flip,
  Get,
  SelfEvict
}
// class Action with parameter value & method incBy

function handle(input: Uint8Array): Uint8Array { // vec<u8>
  const value: Uint8Array = new Uint8Array(0);
  const flipper: Uint8Array = getStorage(FLIPPER_KEY);
  const dataFlipper: DataView = new DataView(flipper.buffer);
  const flipperValue: u8 = dataFlipper.byteLength ? dataFlipper.getUint8(0) : 0;

  // Get action from first byte of the input U8A
  switch (input[0]) {
    case Action.Flip:
      const newFlipperValue: bool = !<bool>flipperValue;
      const newFlipper: Uint8Array = new Uint8Array(1);
      newFlipper[0] = newFlipperValue;
      setStorage(FLIPPER_KEY, newFlipper)
      break;
    case Action.Get:
      // return the counter from storage
      if (flipper.length)
        return flipper;
      break;
    case Action.SelfEvict:
      const allowance = u128.from<u32>(0);
      setRentAllowance(allowance)
      break;
  }
  return value;
}

export function call(): u32 {
  const input: Uint8Array = getScratchBuffer();

  const output: Uint8Array = handle(input);
  setScratchBuffer(output);
  return 0;
}

// deploy a new instance of the contract with the default value 0x00 (false)
export function deploy(): u32 {
  const value: bool = false;
  const newFlipper: Uint8Array = new Uint8Array(1);
  newFlipper[0] = value;

  setStorage(FLIPPER_KEY, newFlipper)
  return 0
}
