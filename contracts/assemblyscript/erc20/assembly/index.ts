import { u256, u128 } from "bignum";

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

import {
  getBalanceOrZero
} from "./lib-contract";

// Create a new Uint8Array of length 32
const ERC20_SUPPLY_STORAGE = (new Uint8Array(32)).fill(3);
const MY_DUMMY = (new Uint8Array(32)).fill(55);

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

  const totalSupply = getStorage(ERC20_SUPPLY_STORAGE);
  const totalSupplyDataView = new DataView(totalSupply.buffer);
  const totalSupplyValue = totalSupplyDataView.byteLength ? totalSupplyDataView.getUint8(0) : 0;

  // Get action from first byte of the input U8A
  switch (input[0]) {
    case Action.TotalSupply: // first byte: 0x00
      // return the counter from storage
      if (totalSupply.length) return toBytes(totalSupplyValue);
      break;
    case Action.BalanceOf: { // first byte: 0x01
      // read 32 bytes (u256) from storageBuffer with offset 1
      const accountId = load<Uint8Array>(input.dataStart, 1);
      const balance = getBalanceOrZero(accountId.subarray(0, 32));
      return balance;
    }
    case Action.Allowance: { // first byte: 0x02
      const inputData = load<Uint8Array>(input.dataStart, 1);
      const owner = inputData.subarray(0, 32);
      const spender = inputData.subarray(32, 64);
      break;
    }
    case Action.Transfer: { // first byte: 0x03
      const inputData = load<u256>(input.dataStart, 1);
      const addressTo = inputData.toUint8Array();
      // const value = inputData.subarray(32, 48);

      setStorage(MY_DUMMY, toBytes(42562));

      // getCaller();
      // const addressFrom = getScratchBuffer();
      // const balance = getBalanceOrZero(addressFrom);

      // const balanceU128 = u128.from<Uint8Array>(balance);
      // const valueU128 = u128.from<Uint8Array>(value);

      // if (balanceU128 >= valueU128){
      //   const balanceAddressTo = getBalanceOrZero(addressTo);
      //   setStorage(addressFrom, (valueU128).toUint8Array() )
      //   setStorage(addressTo, (valueU128).toUint8Array() )
      // }
      break;
    }
    case Action.Approve: { // first byte: 0x04
      const inputData = load<Uint8Array>(input.dataStart, 1);
      const spender = inputData.subarray(0, 32);
      const value = inputData.subarray(0, 48);
      break;
    }
    case Action.TransferFrom: { // first byte: 0x05
      const inputData = load<Uint8Array>(input.dataStart, 1);
      const from = inputData.subarray(0, 32);
      const to = inputData.subarray(32, 64);
      const value = inputData.subarray(64, 80);
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
  // Why are we not returning the output here?
  return 0;
}

// deploy a new instance of the contract with the default value 0x00 (false)
export function deploy(): u32 {
  // Get and store endowment as total supply in scratch buffer
  getValueTransferred()
  const totalSupply = getScratchBuffer();
  setStorage(ERC20_SUPPLY_STORAGE, totalSupply);
  
  // Get and store the address of the caller to scratch buffer 
  getCaller();
  const CALLER = getScratchBuffer();
  // Create a new storage entry with the address of the contract caller
  // and assign the total supply of the contract to the creators account.
  // In more advanced implementations you might want to hash this with a crypto function

  setStorage(CALLER, totalSupply);
  return 0;
}

