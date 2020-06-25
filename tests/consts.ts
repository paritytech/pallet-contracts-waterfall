import BN from "bn.js";

export const WSURL = "ws://127.0.0.1:9944";
export const DOT: BN = new BN("1000000000000000");
export const CREATION_FEE: BN = DOT.muln(200);
export const GAS_REQUIRED = 100000000000;
export const GAS_LIMIT = 0xffff_ffff; // u32::MAX
export const ALICE = "5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY";
export const BOB = "5FHneW46xGXgs5mUiveU4sbTyGBzmstUspZC92UhjJM694ty";
export const CHARLIE = "5FLSigC9HGRKVhB9FiEo4Y3koPsNmBmLJbpXg2mp1hXcS59Y";
export const DAVE = "126TwBzBM4jUEK2gTphmW4oLoBWWnYvPp8hygmduTr4uds57";