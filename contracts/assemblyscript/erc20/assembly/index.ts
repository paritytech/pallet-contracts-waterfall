import { u128 } from "bignum";
import { hash } from "../node_modules/@chainsafe/as-sha256/assembly";

import {
  getCaller,
  getScratchBuffer,
  getStorage,
  getValueTransferred,
  setRentAllowance,
  setScratchBuffer,
  setStorage
} from "./lib";

import {
  getBalanceOrZero,
  toBytes
} from "./lib-contract";

/**
 *  Read the Ethereum ERC20 specs https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 **/ 

const ERC20_SUPPLY_STORAGE = (new Uint8Array(32)).fill(3);

enum Action {
  TotalSupply, // -> Balance
  BalanceOf, // -> Balance
  Transfer, // -> bool
  TransferFrom, // -> bool
  Approve, // -> bool
  Allowance, // -> Balance
  SelfEvict
}

function handle(input: Uint8Array): Uint8Array {
  const value = new Uint8Array(0);
  // Get action from first byte of the input U8A
  switch (input[0]) {
    case Action.TotalSupply: // first byte: 0x00
      const totalSupply = getStorage(ERC20_SUPPLY_STORAGE);
      const totalSupplyDataView = new DataView(totalSupply.buffer);
      const totalSupplyValue = totalSupplyDataView.byteLength ? totalSupplyDataView.getUint8(0) : 0;
      // Returns the total token supply
      return toBytes(totalSupplyValue);
    case Action.BalanceOf: { // first byte: 0x01
      // Returns the account balance of the account with the address 'owner'.
      const owner = Uint8Array.wrap(changetype<ArrayBuffer>(input.dataStart), 1, 32);
      return getBalanceOrZero(owner);
    }
    case Action.Transfer: { // first byte: 0x02
      // Transfers 'value' amount of tokens to address 'to',
      const parameters = Uint8Array.wrap(changetype<ArrayBuffer>(input.dataStart), 1, 48);
      const to = parameters.subarray(0,32);
      const value = u128.from(parameters.subarray(32,48));
      const CALLER = getCaller();
      const balanceFrom = u128.from(getBalanceOrZero(CALLER));
      const balanceTo = u128.from(getBalanceOrZero(to));

      if (u128.ge(balanceFrom,value)) {
        setStorage(CALLER, u128.sub(balanceFrom, value).toUint8Array());
        setStorage(to, u128.add(balanceTo, value).toUint8Array());
      }
      break;
    }
    case Action.TransferFrom: { // first byte: 0x03
      // Transfers 'value' amount of tokens from address 'from' to address 'to'
      const parameters = Uint8Array.wrap(changetype<ArrayBuffer>(input.dataStart), 1, 80);
      const from = parameters.subarray(0,32);
      const to = parameters.subarray(32,64);
      const value = u128.from(parameters.subarray(64,80));
      const balanceFrom = u128.from(getBalanceOrZero(from));
      const balanceTo = u128.from(getBalanceOrZero(to));

      // Merging TypedArrays is not implemented in AssemblyScript yet.
      // That's why we need to read directly from memory
      // See https://stackoverflow.com/questions/59270312/concatenate-or-merge-typedarrays-in-assemblyscript
      // Also this PR https://github.com/AssemblyScript/assemblyscript/pull/1002
      const storageKeyApprove = new Uint8Array(64);
      const fromPtr = from.dataStart;
      const toPtr = to.dataStart;
      const keyPtr = storageKeyApprove.dataStart;
      memory.copy(keyPtr, fromPtr, 32);
      memory.copy(keyPtr + 32, toPtr, 32);

      const sha256 = hash(storageKeyApprove);
      const allowance = u128.from(getBalanceOrZero(sha256));

      // @TODO add allowance check here
      if (u128.ge(balanceFrom,value) && u128.ge(allowance, value)) {
        setStorage(from, u128.sub(balanceFrom, value).toUint8Array());
        setStorage(to, u128.add(balanceTo, value).toUint8Array());
        // @TODO deduct from allowance
      }
      break;
    }
    case Action.Approve: { // first byte: 0x04
      // Allows 'spender' to withdraw from your account multiple times, up to the 'value' amount
      const parameters = Uint8Array.wrap(changetype<ArrayBuffer>(input.dataStart), 1, 48);
      const spender: Uint8Array = parameters.subarray(0,32);
      const amount = parameters.subarray(32,48);
      const CALLER = getCaller();

      // Merging TypedArrays is not implemented in AssemblyScript yet.
      // That's why we need to read directly from memory
      // See https://stackoverflow.com/questions/59270312/concatenate-or-merge-typedarrays-in-assemblyscript
      // Also this PR https://github.com/AssemblyScript/assemblyscript/pull/1002
      const storageKeyApprove = new Uint8Array(64);
      const callerPtr = CALLER.dataStart;
      const spenderPtr = spender.dataStart;
      const keyPtr = storageKeyApprove.dataStart;
      memory.copy(keyPtr, callerPtr, 32);
      memory.copy(keyPtr + 32, spenderPtr, 32);

      const sha256 = hash(storageKeyApprove);
      setStorage(sha256, amount);

      break;
    }
    case Action.Allowance: { // first byte: 0x05
      // Returns the amount which 'spender' is still allowed to withdraw from 'owner'
      const parameters = Uint8Array.wrap(changetype<ArrayBuffer>(input.dataStart), 1, 64);
      const owner = parameters.subarray(0,32);
      const spender = parameters.subarray(32,64);

      // const storageKeyAllowance = new Uint8Array(64);
      // const ownerPtr = owner.dataStart;
      // const spenderPtr = spender.dataStart;
      // const keyPtr = storageKeyAllowance.dataStart;

      // memory.copy(keyPtr, ownerPtr, 32);
      // memory.copy(keyPtr + 32, spenderPtr, spenderPtr);

      // const allowance = getStorage(storageKeyAllowance);
      // const allowanceDataView = new DataView(allowance.buffer);
      // const allowanceValue = allowanceDataView.byteLength ? allowanceDataView.getUint8(0) : 0;

      setStorage(owner, toBytes(0));

      // return toBytes(allowanceValue);
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
  // Get and store endowment as total supply in scratch buffer
  const totalSupply = getValueTransferred();
  setStorage(ERC20_SUPPLY_STORAGE, totalSupply);

  // Create a new storage entry with the address of the contract caller
  // and assign the total supply of the contract to the creators account.
  // In more advanced implementations you might want to hash this with a crypto function
  const CALLER = getCaller();
  setStorage(CALLER, totalSupply);
  return 0;
}

