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

//! A generic owned restoration contract.
//!
//! Can be used for restoring a tombstoned contracts.

#![feature(alloc_error_handler)]

#![no_std]

#[macro_use]
extern crate parity_codec_derive;
extern crate parity_codec as codec;
extern crate wee_alloc;

extern crate alloc;

use core::arch::wasm32;
use alloc::vec::Vec;
use codec::{Encode, Decode};

mod ext;

// Use `wee_alloc` as the global allocator.
#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;

#[panic_handler]
#[no_mangle]
pub fn panic(_info: &::core::panic::PanicInfo) -> ! {
	unsafe {
		wasm32::unreachable()
	}
}

#[alloc_error_handler]
pub extern fn oom(_: ::core::alloc::Layout) -> ! {
	unsafe {
		wasm32::unreachable()
	}
}

#[derive(Encode, Decode)]
enum Action {
    Put {
        key: ext::Key,
        value: Option<Vec<u8>>,
    },
    Restore {
        dest_addr: ext::AccountId,
        code_hash: ext::CodeHash,
        rent_allowance: ext::Balance,
    },
}

// This is very important to not collide with the restored contract.
static OWNER_KEY: ext::Key = [0x42; 32];

fn handle(action: Action) {
    let owner = {
        let raw_owner = ext::get_storage(&OWNER_KEY).unwrap();
        ext::AccountId::decode(&mut &raw_owner[..]).unwrap()
    };
    if owner != ext::caller() {
        panic!();
    }

    match action {
        Action::Put { key, value } => {
            ext::set_storage(&key, value.as_ref().map(|v| v.as_ref()));
        }
        Action::Restore {
            dest_addr,
            code_hash,
            rent_allowance,
        } => {
            ext::restore(
                &dest_addr,
                &code_hash,
                rent_allowance,
                &[OWNER_KEY],
            );
        }
    }
}

#[no_mangle]
pub extern "C" fn call() -> u32 {
    let input = ext::scratch_buf();
    let action = Action::decode(&mut &input[..]).unwrap();

    handle(action);

    ext::scratch_buf_set(&[]);

    // Check if the caller equals to the owner
    0
}

#[no_mangle]
pub extern "C" fn deploy() -> u32 {
    let caller = ext::caller();
    ext::set_storage(&OWNER_KEY, Some(&caller.encode()));
    ext::scratch_buf_set(&[]);
    0
}
