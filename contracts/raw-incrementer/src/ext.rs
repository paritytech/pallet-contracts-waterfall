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
use codec::Encode;

mod cabi {
    extern "C" {
        pub fn ext_set_storage(key_ptr: u32, value_non_null: u32, value_ptr: u32, value_len: u32);
        pub fn ext_get_storage(key_ptr: u32) -> u32;
        pub fn ext_scratch_size() -> u32;
        pub fn ext_scratch_read(dest_ptr: u32, offset: u32, len: u32);
        pub fn ext_scratch_write(src_ptr: u32, len: u32);
        pub fn ext_println(ptr: u32, len: u32);
        pub fn ext_set_rent_allowance(value_ptr: u32, value_len: u32);
    }
}

pub struct Key(pub [u8; 32]);

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

        cabi::ext_set_storage(key.0.as_ptr() as u32, value_non_null, value_ptr, value_len);
    }
}


pub fn get_storage(key: &Key) -> Option<Vec<u8>> {
    const ERR_OK: u32 = 0;
    unsafe {
        let result = cabi::ext_get_storage(key.0.as_ptr() as u32);
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

pub fn set_rent_allowance(value: u128) {
    let value_buf = value.encode();
    unsafe {
        cabi::ext_set_rent_allowance(
            value_buf.as_ptr() as usize as u32,
            value_buf.len() as u32,
        );
    }
}
