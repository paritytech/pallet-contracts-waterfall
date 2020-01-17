import { ApiPromise, SubmittableResult } from "@polkadot/api";
import { KeyringPair } from "@polkadot/keyring/types";
import { Option, StorageData } from "@polkadot/types";
import { Address, ContractInfo, Hash } from "@polkadot/types/interfaces";
import { u8aToHex } from "@polkadot/util";
import BN from "bn.js";
import fs from "fs";
import path from "path";
const blake = require('blakejs');

import { GAS_REQUIRED } from "./consts";

export async function sendAndReturnFinalized(signer: KeyringPair, tx: any) {
  return new Promise(function(resolve, reject) {
    tx.signAndSend(signer, (result: SubmittableResult) => {
      if (result.status.isFinalized) {
        // Return result of the submittable extrinsic after the transfer is finalized
        resolve(result as SubmittableResult);
      }
      if (
        result.status.isDropped ||
        result.status.isInvalid ||
        result.status.isUsurped
      ) {
        reject(result as SubmittableResult);
        console.error("ERROR: Transaction could not be finalized.");
      }
    });
  });
}

export async function putCode(
  api: ApiPromise,
  signer: KeyringPair,
  fileName: string,
  gasRequired: number = GAS_REQUIRED
): Promise<Hash> {
  const wasmCode = fs
    .readFileSync(path.join(__dirname, fileName))
    .toString("hex");
  const tx = api.tx.contracts.putCode(gasRequired, `0x${wasmCode}`);
  const result: any = await sendAndReturnFinalized(signer, tx);
  const record = result.findRecord("contracts", "CodeStored");

  if (!record) {
    console.error("ERROR: No code stored after executing putCode()");
  }
  // Return code hash.
  return record.event.data[0];
}

export async function instantiate(
  api: ApiPromise,
  signer: KeyringPair,
  codeHash: Hash,
  inputData: any,
  endowment: BN,
  gasRequired: number = GAS_REQUIRED
): Promise<Address> {
  const tx = api.tx.contracts.instantiate(
    endowment,
    gasRequired,
    codeHash,
    inputData
  );
  const result: any = await sendAndReturnFinalized(signer, tx);
  const record = result.findRecord("contracts", "Instantiated");

  if (!record) {
    console.error("ERROR: No new instantiated contract");
  }
  // Return the address of instantiated contract.
  return record.event.data[1];
}

export async function callContract(
  api: ApiPromise,
  signer: KeyringPair,
  contractAddress: Address,
  inputData: any,
  gasRequired: number = GAS_REQUIRED,
  endowment: number = 0
): Promise<void> {
  const tx = api.tx.contracts.call(
    contractAddress,
    endowment,
    gasRequired,
    inputData
  );

  await sendAndReturnFinalized(signer, tx);
}

export async function getContractStorage(
  api: ApiPromise,
  contractAddress: Address,
  storageKey: Uint8Array
): Promise<StorageData> {
  const contractInfo = await api.query.contracts.contractInfoOf(
    contractAddress
  );

  // Return the value of the contracts storage
  const childStorageKey = (contractInfo as Option<ContractInfo>).unwrap().asAlive.trieId;
  const childInfo = childStorageKey.subarray(childStorageKey.byteLength -32, childStorageKey.byteLength);
  const storageKeyBlake2b = blake.blake2bHex(storageKey, null, 32);

  return await api.rpc.state.getChildStorage(
    u8aToHex(childStorageKey), // trieId
    u8aToHex(childInfo), // trieId without `:child_storage:` prefix
    1, // substrate default value `1`
    '0x' + storageKeyBlake2b // hashed storageKey
  );
}
