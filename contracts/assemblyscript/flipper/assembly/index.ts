import { u128 } from "bignum";

import {
  getScratchBuffer,
  getStorage,
  setRentAllowance,
  setScratchBuffer,
  setStorage
} from './lib';


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

function handle(input: Uint8Array): Uint8Array {
  const value : Uint8Array = new Uint8Array(0); // new value that will be returned
  const flipper: Uint8Array = getStorage(FLIPPER_KEY); // existing storage at storage kez
  const dataFlipper: DataView = new DataView(flipper.buffer);
  const flipperValue: bool = dataFlipper.byteLength ? dataFlipper.getUint32(0, true) : 0;

  // Get action from first byte of the input U8A
  switch (input[0]) {
    case Action.Flip:
      setStorage(FLIPPER_KEY, flipperValue)
      break;
    case Action.Get:
      // return the flipper from storage
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

// deploy a new instance of the contract
export function deploy(): u32 {
  const value : Uint8Array = new Uint8Array(0); 
  setStorage(FLIPPER_KEY, value)
  return 0
}
