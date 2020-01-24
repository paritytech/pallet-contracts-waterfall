// Declaration of imported host functions from substrate pallet-contracts
//
// We're using these module function declarations in our lib.ts file
// If these functions are not used by our AssemblyScript module, they will not be included
// in the compiled wat and wasm files.


export declare function ext_balance(): void;
export declare function ext_caller(): void;
export declare function ext_get_storage(key_ptr: i32): i32;
export declare function ext_println(str_ptr: i32, str_len: i32): void;
export declare function ext_scratch_read(dest_ptr: i32, offset: i32, len: i32): void;
export declare function ext_scratch_size(): i32;
export declare function ext_scratch_write(src_ptr: i32, len: i32): void;
export declare function ext_set_rent_allowance(value_ptr: i32, value_len: i32): void;
export declare function ext_set_storage(key_ptr: i32, value_non_null: i32, value_ptr: i32, value_len: i32): void;
export declare function ext_value_transferred(): void;
