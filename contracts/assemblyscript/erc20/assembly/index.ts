import { u128 } from "bignum";

import {
  getScratchBuffer,
  getStorage,
  setRentAllowance,
  setScratchBuffer,
  setStorage,
  toBytes
} from "./lib";

// Create a new Uint8Array of length 32
const ERC20_KEY = (new Uint8Array(32) as Uint8Array).fill(3);

enum Action {
  TotalSupply, // -> Balance
  BalanceOf, // -> Balance
  Allowance, // -> Balance
  Transfer, // -> bool
  Approve, // -> bool
  TransferFrom, // -> bool
  SelfEvict
}

function handle(input: Uint8Array): Uint8Array {
  const value = new Uint8Array(0);
  const erc20 = getStorage(ERC20_KEY);
  const dataErc20 = new DataView(erc20.buffer);
  const erc20Value = dataErc20.byteLength ? dataErc20.getUint8(0) : 0;

  // Get action from first byte of the input U8A
  switch (input[0]) {
    case Action.TotalSupply: // first byte: 0x00
      // return the counter from storage
      if (erc20.length) return erc20;
      break;
    case Action.BalanceOf: { // first byte: 0x01
      // read 4 bytes (u32) from storageBuffer with offset 1
      const owner = load<u32>(input.dataStart, 1);
      const newCounter = toBytes(erc20Value + owner);
      setStorage(ERC20_KEY, newCounter);
      break;
    }
    case Action.Allowance: { // first byte: 0x02
      const owner = load<u32>(input.dataStart, 1);
      const spender = load<u32>(input.dataStart, 5);
      if (erc20.length) return erc20;
      break;
    }
    case Action.Transfer: { // first byte: 0x03
      const to = load<u32>(input.dataStart, 1);
      const value = load<u32>(input.dataStart, 5);
      // return the counter from storage
      if (erc20.length) return erc20;
      break;
    }
    case Action.Approve: { // first byte: 0x04
      const spender = load<u32>(input.dataStart, 1);
      const value = load<u32>(input.dataStart, 5);
      // return the counter from storage
      if (erc20.length) return erc20;
      break;
    }
    case Action.TransferFrom: { // first byte: 0x05
      const from = load<u32>(input.dataStart, 1);
      const to = load<u32>(input.dataStart, 5);
      const value = load<u32>(input.dataStart, 9);
      // return the counter from storage
      if (erc20.length) return erc20;
      break;
    }
    case Action.SelfEvict: // first byte: 0x06
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
  const totalSupply = toBytes(10000000055);
  setStorage(ERC20_KEY, totalSupply);
  return 0;
}
