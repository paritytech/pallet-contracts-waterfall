import { u128 } from "bignum";

import {
  getCaller,
  getScratchBuffer,
  getStorage,
  getValueTransferred,
  setRentAllowance,
  setScratchBuffer,
  setStorage,
  toBytes
} from "./lib";

// Create a new Uint8Array of length 32
const ERC20_SUPPLY_STORAGE = (new Uint8Array(32)).fill(3);

enum Action {
  TotalSupply, // -> Balance
  BalanceOf, // -> Balance
  // Allowance, // -> Balance
  // Transfer, // -> bool
  // Approve, // -> bool
  // TransferFrom, // -> bool
  SelfEvict
}

function handle(input: Uint8Array): Uint8Array {
  const value = new Uint8Array(0);

  const totalSupply = getStorage(ERC20_SUPPLY_STORAGE);
  const totalSupplyDataView = new DataView(totalSupply.buffer);
  const totalSupplyValue = totalSupplyDataView.byteLength ? totalSupplyDataView.getUint8(0) : 0;

  // Get action from first byte of the input U8A
  switch (input[0]) {
    case Action.TotalSupply: // first byte: 0x00
      // return the counter from storage
      if (totalSupply.length) return totalSupply;
      break;
    case Action.BalanceOf: { // first byte: 0x01
      // read 4 bytes (u32) from storageBuffer with offset 1
      const owner = toBytes(load<u32>(input.dataStart, 1));
      const balance = getStorage(owner);
      const balanceDataView = new DataView(balance.buffer);
      const balanceValue = balanceDataView.byteLength ? balanceDataView.getUint8(0) : 0;

      return toBytes(balanceValue);
      break;
    }
    // case Action.Allowance: { // first byte: 0x02
    //   const owner = load<u32>(input.dataStart, 1);
    //   const spender = load<u32>(input.dataStart, 5);
    //   if (totalSupply.length) return totalSupply;
    //   break;
    // }
    // case Action.Transfer: { // first byte: 0x03
    //   const to = load<u32>(input.dataStart, 1);
    //   const value = load<u32>(input.dataStart, 5);
    //   // return the counter from storage
    //   if (totalSupply.length) return totalSupply;
    //   break;
    // }
    // case Action.Approve: { // first byte: 0x04
    //   const spender = load<u32>(input.dataStart, 1);
    //   const value = load<u32>(input.dataStart, 5);
    //   // return the counter from storage
    //   if (totalSupply.length) return totalSupply;
    //   break;
    // }
    // case Action.TransferFrom: { // first byte: 0x05
    //   const from = load<u32>(input.dataStart, 1);
    //   const to = load<u32>(input.dataStart, 5);
    //   const value = load<u32>(input.dataStart, 9);
    //   // return the counter from storage
    //   if (totalSupply.length) return totalSupply;
    //   break;
    // }
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
  // Get and store endowment as total supply
  getValueTransferred()
  const totalSupply = getScratchBuffer();
  setStorage(ERC20_SUPPLY_STORAGE, totalSupply);
  
  // Get and store the address of the caller to scratch buffer 
  getCaller();
  const caller = getScratchBuffer();
  // Create a new storage entry with the address of the contract caller
  // and assign the total supply of the contract to the creators account.
  // In more advanced implementations you might want to hash this with a crypto function
  const ERC20_CREATOR = (new Uint8Array(32));
  setStorage(ERC20_CREATOR, totalSupply);
  return 0;
}
