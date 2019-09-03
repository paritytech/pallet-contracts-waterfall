//! Implementation of a simple smart-contract using only raw APIs.

#![feature(alloc_error_handler)]

#![no_std]

#[macro_use]
extern crate parity_codec_derive;
extern crate parity_codec as codec;
extern crate wee_alloc;

#[macro_use]
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
    Inc(u32),
    Get,
    SelfEvict,
}

static COUNTER_KEY: ext::Key = ext::Key([1; 32]);

fn handle(input: &[u8]) -> Vec<u8> {
    let action = Action::decode(&mut &input[..]).unwrap();

    match action {
        Action::Inc(by) => {
            ext::println("inc");
            let mut counter = ext::get_storage(&COUNTER_KEY).and_then(|v| u32::decode(&mut &v[..])).unwrap_or(0);
            counter += by;
            ext::set_storage(&COUNTER_KEY, Some(&u32::encode(&counter)));
            Vec::new()
        }
        Action::Get => {
            ext::println("get");
            let raw_counter = ext::get_storage(&COUNTER_KEY).unwrap_or(vec![]);
            raw_counter.to_vec()
        }
        Action::SelfEvict => {
            // Effectively self-evict.
            ext::println("self-evict");
            ext::set_rent_allowance(0);
            Vec::new()
        }
    }
}

#[no_mangle]
pub extern "C" fn call() -> u32 {
    // Get the input data for the execution. It is placed into the scratch buffer.
    let input = ext::scratch_buf();

    // Handle the message.
    let output = handle(&input);

    // Always overwrite the scratch buffer.
    ext::scratch_buf_set(&output);

    // Return 0 (ERR_OK)
    0
}

// We need to define `deploy` function, so the wasm-build will produce a constructor binary.
#[no_mangle]
pub extern "C" fn deploy() -> u32 {
    0
}
