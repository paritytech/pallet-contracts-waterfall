// Copyright 2019 Parity Technologies (UK) Ltd.
// This file is part of Substrate.

// Substrate is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// Substrate is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Substrate. If not, see <http://www.gnu.org/licenses/>.

use alloc::vec::Vec;
use codec::{Encode, Decode};

mod cabi {
    extern "C" {
        pub fn ext_set_storage(key_ptr: u32, value_non_null: u32, value_ptr: u32, value_len: u32);
        pub fn ext_restore_to(
            dest_ptr: u32,
            dest_len: u32,
            code_hash_ptr: u32,
            code_hash_len: u32,
            rent_allowance_ptr: u32,
            rent_allowance_len: u32,
            delta_ptr: u32,
            delta_count: u32
        );
        pub fn ext_get_storage(key_ptr: u32) -> u32;
        pub fn ext_scratch_size() -> u32;
        pub fn ext_scratch_read(dest_ptr: u32, offset: u32, len: u32);
        pub fn ext_scratch_write(src_ptr: u32, len: u32);
        pub fn ext_println(ptr: u32, len: u32);
        pub fn ext_caller();
    }
}

pub type AccountId = [u8; 32];
pub type CodeHash = [u8; 32];
pub type Balance = u128;
pub type Key = [u8; 32];

pub fn set_storage(key: &Key, value: Option<&[u8]>) {
    unsafe {
        let mut value_ptr = 0;
        let mut value_len = 0;
        let value_non_null = if let Some(v) = value {
            value_ptr = v.as_ptr() as u32;
            value_len = v.len() as u32;
            1
        } else {
            0
        };

        cabi::ext_set_storage(key.as_ptr() as u32, value_non_null, value_ptr, value_len);
    }
}


pub fn get_storage(key: &Key) -> Option<Vec<u8>> {
    const ERR_OK: u32 = 0;
    unsafe {
        let result = cabi::ext_get_storage(key.as_ptr() as u32);
        if result == ERR_OK {
            let size = cabi::ext_scratch_size();
            let mut value = Vec::new();
            if size > 0 {
                value.resize(size as usize, 0);
                cabi::ext_scratch_read(value.as_mut_ptr() as u32, 0, size);
            }
            Some(value)
        } else {
            None
        }
    }
}

pub fn scratch_buf() -> Vec<u8> {
    unsafe {
        let size = cabi::ext_scratch_size();
        if size == 0 {
            return Vec::new();
        }

        let mut value = Vec::new();
        if size > 0 {
            value.resize(size as usize, 0);
            cabi::ext_scratch_read(value.as_mut_ptr() as u32, 0, size);
        }
        value
    }
}

pub fn scratch_buf_set(data: &[u8]) {
    unsafe {
        cabi::ext_scratch_write(data.as_ptr() as u32, data.len() as u32);
    }
}

pub fn println(msg: &str) {
    unsafe {
        cabi::ext_println(msg.as_ptr() as u32, msg.len() as u32);
    }
}

pub fn caller() -> AccountId {
    unsafe {
        cabi::ext_caller();
        let scratch_buf = scratch_buf();
        AccountId::decode(&mut &scratch_buf[..]).unwrap()
    }
}

pub fn restore(dest_addr: &AccountId, code_hash: &CodeHash, rent_allowance: Balance, delta: &[Key]) {
    let rent_allowance_buf = rent_allowance.encode();
    unsafe {
        cabi::ext_restore_to(
            dest_addr.as_ptr() as usize as u32,
            dest_addr.len() as u32,
            code_hash.as_ptr() as usize as u32,
            code_hash.len() as u32,
            rent_allowance_buf.as_ptr() as usize as u32,
            rent_allowance_buf.len() as u32,
            delta.as_ptr() as usize as u32,
            delta.len() as u32,
        );
    }
}
