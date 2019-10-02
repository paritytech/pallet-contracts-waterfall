(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (param i32 i32) (result i32)))
  (type (;2;) (func (result i32)))
  (type (;3;) (func (param i32 i32 i32)))
  (type (;4;) (func (param i32 i32)))
  (type (;5;) (func (param i32 i32 i32 i32)))
  (type (;6;) (func (param i32)))
  (type (;7;) (func))
  (type (;8;) (func (param i32 i32 i32 i32 i32) (result i32)))
  (type (;9;) (func (param i32 i32 i32) (result i32)))
  (import "env" "memory" (memory (;0;) 2 16))
  (import "env" "ext_scratch_size" (func $ext_scratch_size (type 2)))
  (import "env" "ext_scratch_read" (func $ext_scratch_read (type 3)))
  (import "env" "ext_println" (func $ext_println (type 4)))
  (import "env" "ext_set_rent_allowance" (func $ext_set_rent_allowance (type 4)))
  (import "env" "ext_set_storage" (func $ext_set_storage (type 5)))
  (import "env" "ext_scratch_write" (func $ext_scratch_write (type 4)))
  (import "env" "ext_get_storage" (func $ext_get_storage (type 0)))
  (func $rust_oom (type 4) (param i32 i32)
    unreachable
    unreachable)
  (func $call (type 2) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 0
    global.set 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          call $ext_scratch_size
                          local.tee 1
                          br_if 0 (;@11;)
                          i32.const 1
                          local.set 2
                          i32.const 0
                          local.set 3
                          i32.const 0
                          local.set 1
                          br 1 (;@10;)
                        end
                        local.get 1
                        i32.const 0
                        i32.lt_s
                        br_if 2 (;@8;)
                        local.get 1
                        call $__rust_alloc
                        local.tee 2
                        i32.eqz
                        br_if 1 (;@9;)
                        i32.const 0
                        local.set 4
                        local.get 2
                        local.set 3
                        block  ;; label = @11
                          local.get 1
                          i32.const 1
                          i32.le_u
                          br_if 0 (;@11;)
                          local.get 1
                          i32.const -1
                          i32.add
                          local.set 3
                          i32.const 0
                          local.set 4
                          loop  ;; label = @12
                            local.get 2
                            local.get 4
                            i32.add
                            i32.const 0
                            i32.store8
                            local.get 3
                            local.get 4
                            i32.const 1
                            i32.add
                            local.tee 4
                            i32.ne
                            br_if 0 (;@12;)
                          end
                          local.get 2
                          local.get 4
                          i32.add
                          local.set 3
                        end
                        local.get 3
                        i32.const 0
                        i32.store8
                        local.get 2
                        i32.const 0
                        local.get 1
                        call $ext_scratch_read
                        local.get 4
                        i32.const 1
                        i32.add
                        local.set 3
                      end
                      local.get 0
                      i32.const 0
                      i32.store8
                      local.get 0
                      local.get 2
                      local.get 3
                      i32.const 0
                      i32.ne
                      local.tee 5
                      call $memcpy
                      local.set 4
                      local.get 3
                      local.get 5
                      i32.lt_u
                      br_if 2 (;@7;)
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              local.get 3
                              i32.eqz
                              br_if 0 (;@13;)
                              local.get 4
                              i32.load8_u
                              local.tee 0
                              i32.const 2
                              i32.gt_u
                              br_if 0 (;@13;)
                              block  ;; label = @14
                                local.get 0
                                br_table 0 (;@14;) 4 (;@10;) 2 (;@12;) 0 (;@14;)
                              end
                              local.get 4
                              i32.const 0
                              i32.store
                              local.get 4
                              local.get 2
                              local.get 5
                              i32.add
                              local.get 3
                              local.get 5
                              i32.sub
                              local.tee 0
                              i32.const 4
                              local.get 0
                              i32.const 4
                              i32.lt_u
                              select
                              call $memcpy
                              local.set 3
                              local.get 0
                              i32.const 3
                              i32.gt_u
                              br_if 2 (;@11;)
                            end
                            i32.const 65628
                            call $_ZN4core9panicking5panic17h76795e44271f3481E
                            unreachable
                          end
                          i32.const 65568
                          i32.const 10
                          call $ext_println
                          i32.const 16
                          call $__rust_alloc
                          local.tee 3
                          i32.eqz
                          br_if 5 (;@6;)
                          local.get 3
                          i64.const 0
                          i64.store offset=8 align=1
                          local.get 3
                          i64.const 0
                          i64.store align=1
                          local.get 3
                          i32.const 16
                          call $ext_set_rent_allowance
                          local.get 3
                          i32.const 16
                          call $__rust_dealloc
                          br 9 (;@2;)
                        end
                        local.get 3
                        i32.load
                        local.set 6
                        i32.const 65581
                        i32.const 3
                        call $ext_println
                        local.get 3
                        call $_ZN15raw_incrementer3ext11get_storage17hc862bf4f41c41a7fE
                        block  ;; label = @11
                          block  ;; label = @12
                            local.get 3
                            i32.load
                            local.tee 7
                            i32.eqz
                            br_if 0 (;@12;)
                            local.get 3
                            i32.const 8
                            i32.add
                            i32.load
                            local.set 0
                            local.get 3
                            i32.load offset=4
                            local.set 8
                            local.get 3
                            i32.const 0
                            i32.store offset=12
                            local.get 3
                            i32.const 12
                            i32.add
                            local.get 7
                            local.get 0
                            i32.const 4
                            local.get 0
                            i32.const 4
                            i32.lt_u
                            select
                            call $memcpy
                            drop
                            local.get 3
                            i32.load offset=12
                            local.set 5
                            block  ;; label = @13
                              local.get 8
                              i32.eqz
                              br_if 0 (;@13;)
                              local.get 7
                              local.get 8
                              call $__rust_dealloc
                            end
                            local.get 0
                            i32.const 3
                            i32.gt_u
                            br_if 1 (;@11;)
                          end
                          i32.const 0
                          local.set 5
                        end
                        i32.const 4
                        call $__rust_alloc
                        local.tee 3
                        i32.eqz
                        br_if 5 (;@5;)
                        local.get 3
                        local.get 5
                        local.get 6
                        i32.add
                        i32.store align=1
                        i32.const 65536
                        i32.const 1
                        local.get 3
                        i32.const 4
                        call $ext_set_storage
                        local.get 3
                        i32.const 4
                        call $__rust_dealloc
                        br 8 (;@2;)
                      end
                      i32.const 65578
                      i32.const 3
                      call $ext_println
                      local.get 4
                      call $_ZN15raw_incrementer3ext11get_storage17hc862bf4f41c41a7fE
                      local.get 4
                      i32.const 8
                      i32.add
                      i32.load
                      i32.const 0
                      local.get 4
                      i32.load
                      local.tee 0
                      select
                      local.tee 3
                      i32.const -1
                      i32.le_s
                      br_if 5 (;@4;)
                      local.get 4
                      i32.load offset=4
                      local.set 7
                      i32.const 1
                      local.set 5
                      block  ;; label = @10
                        local.get 3
                        i32.eqz
                        br_if 0 (;@10;)
                        local.get 3
                        call $__rust_alloc
                        local.tee 5
                        i32.eqz
                        br_if 7 (;@3;)
                      end
                      local.get 5
                      local.get 0
                      i32.const 1
                      local.get 0
                      select
                      local.tee 6
                      local.get 3
                      call $memcpy
                      local.set 5
                      block  ;; label = @10
                        local.get 7
                        i32.const 0
                        local.get 0
                        select
                        local.tee 0
                        i32.eqz
                        br_if 0 (;@10;)
                        local.get 6
                        local.get 0
                        call $__rust_dealloc
                      end
                      local.get 5
                      local.get 3
                      call $ext_scratch_write
                      local.get 3
                      i32.eqz
                      br_if 8 (;@1;)
                      local.get 5
                      local.get 3
                      call $__rust_dealloc
                      br 8 (;@1;)
                    end
                    local.get 1
                    i32.const 1
                    call $rust_oom
                    unreachable
                  end
                  call $_ZN5alloc7raw_vec17capacity_overflow17h159a6426f442e157E
                  unreachable
                end
                local.get 5
                local.get 3
                call $_ZN4core5slice22slice_index_order_fail17hcdfc65392f282fd5E
                unreachable
              end
              i32.const 16
              i32.const 1
              call $rust_oom
              unreachable
            end
            i32.const 4
            i32.const 1
            call $rust_oom
            unreachable
          end
          call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$11allocate_in28_$u7b$$u7b$closure$u7d$$u7d$17h9d7d178c66d8a5c8E
          unreachable
        end
        local.get 3
        i32.const 1
        call $rust_oom
        unreachable
      end
      i32.const 1
      i32.const 0
      call $ext_scratch_write
    end
    block  ;; label = @1
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      local.get 2
      local.get 1
      call $__rust_dealloc
    end
    local.get 4
    i32.const 16
    i32.add
    global.set 0
    i32.const 0)
  (func $__rust_alloc (type 0) (param i32) (result i32)
    local.get 0
    call $__rg_alloc)
  (func $_ZN4core9panicking5panic17h76795e44271f3481E (type 6) (param i32)
    call $_ZN4core9panicking9panic_fmt17h208bc982e6cfe835E
    unreachable)
  (func $__rust_dealloc (type 4) (param i32 i32)
    local.get 0
    local.get 1
    call $__rg_dealloc)
  (func $_ZN15raw_incrementer3ext11get_storage17hc862bf4f41c41a7fE (type 6) (param i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      i32.const 65536
      call $ext_get_storage
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.const 0
      i32.store
      return
    end
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            call $ext_scratch_size
            local.tee 1
            br_if 0 (;@4;)
            i32.const 1
            local.set 2
            i32.const 0
            local.set 3
            i32.const 0
            local.set 1
            br 1 (;@3;)
          end
          local.get 1
          i32.const 0
          i32.lt_s
          br_if 2 (;@1;)
          local.get 1
          call $__rust_alloc
          local.tee 2
          i32.eqz
          br_if 1 (;@2;)
          local.get 2
          local.set 4
          i32.const 0
          local.set 3
          block  ;; label = @4
            local.get 1
            i32.const 1
            i32.le_u
            br_if 0 (;@4;)
            local.get 1
            i32.const -1
            i32.add
            local.set 4
            i32.const 0
            local.set 3
            loop  ;; label = @5
              local.get 2
              local.get 3
              i32.add
              i32.const 0
              i32.store8
              local.get 4
              local.get 3
              i32.const 1
              i32.add
              local.tee 3
              i32.ne
              br_if 0 (;@5;)
            end
            local.get 2
            local.get 3
            i32.add
            local.set 4
          end
          local.get 4
          i32.const 0
          i32.store8
          local.get 2
          i32.const 0
          local.get 1
          call $ext_scratch_read
          local.get 3
          i32.const 1
          i32.add
          local.set 3
        end
        local.get 0
        local.get 1
        i32.store offset=4
        local.get 0
        local.get 2
        i32.store
        local.get 0
        i32.const 8
        i32.add
        local.get 3
        i32.store
        return
      end
      local.get 1
      i32.const 1
      call $rust_oom
      unreachable
    end
    call $_ZN5alloc7raw_vec17capacity_overflow17h159a6426f442e157E
    unreachable)
  (func $_ZN5alloc7raw_vec17capacity_overflow17h159a6426f442e157E (type 7)
    i32.const 65584
    call $_ZN4core9panicking5panic17h76795e44271f3481E
    unreachable)
  (func $_ZN4core5slice22slice_index_order_fail17hcdfc65392f282fd5E (type 4) (param i32 i32)
    call $_ZN4core9panicking9panic_fmt17h208bc982e6cfe835E
    unreachable)
  (func $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$11allocate_in28_$u7b$$u7b$closure$u7d$$u7d$17h9d7d178c66d8a5c8E (type 7)
    call $_ZN5alloc7raw_vec17capacity_overflow17h159a6426f442e157E
    unreachable)
  (func $deploy (type 2) (result i32)
    i32.const 0)
  (func $__rg_alloc (type 0) (param i32) (result i32)
    local.get 0
    call $_ZN64_$LT$wee_alloc..WeeAlloc$u20$as$u20$core..alloc..GlobalAlloc$GT$5alloc17h1e6fa0f2752bb80fE)
  (func $_ZN64_$LT$wee_alloc..WeeAlloc$u20$as$u20$core..alloc..GlobalAlloc$GT$5alloc17h1e6fa0f2752bb80fE (type 0) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 1
    global.set 0
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        br_if 0 (;@2;)
        i32.const 1
        local.set 0
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        i32.const 3
        i32.add
        local.tee 2
        i32.const 2
        i32.shr_u
        local.tee 3
        i32.const -1
        i32.add
        local.tee 0
        i32.const 255
        i32.gt_u
        br_if 0 (;@2;)
        local.get 1
        i32.const 65812
        i32.store offset=4
        local.get 1
        local.get 0
        i32.const 2
        i32.shl
        i32.const 65816
        i32.add
        local.tee 2
        i32.load
        i32.store offset=8
        block  ;; label = @3
          local.get 3
          i32.const 1
          local.get 1
          i32.const 8
          i32.add
          local.get 1
          i32.const 4
          i32.add
          i32.const 65740
          call $_ZN9wee_alloc15alloc_first_fit17h2958d0738bb374faE.llvm.1804655379480408609
          local.tee 0
          br_if 0 (;@3;)
          local.get 1
          local.get 1
          i32.load offset=4
          local.tee 4
          i32.load
          i32.store offset=12
          block  ;; label = @4
            block  ;; label = @5
              local.get 3
              i32.const 2
              i32.add
              local.tee 0
              local.get 0
              i32.mul
              local.tee 0
              i32.const 2048
              local.get 0
              i32.const 2048
              i32.gt_u
              select
              local.tee 5
              i32.const 4
              local.get 1
              i32.const 12
              i32.add
              i32.const 1
              i32.const 65788
              call $_ZN9wee_alloc15alloc_first_fit17h2958d0738bb374faE.llvm.1804655379480408609
              local.tee 6
              i32.eqz
              br_if 0 (;@5;)
              local.get 4
              local.get 1
              i32.load offset=12
              i32.store
              local.get 5
              i32.const 2
              i32.shl
              local.set 7
              br 1 (;@4;)
            end
            block  ;; label = @5
              local.get 5
              i32.const 2
              i32.shl
              local.tee 7
              i32.const 16416
              local.get 7
              i32.const 16416
              i32.gt_u
              select
              i32.const 65543
              i32.add
              local.tee 0
              i32.const 16
              i32.shr_u
              memory.grow
              local.tee 6
              i32.const -1
              i32.ne
              br_if 0 (;@5;)
              local.get 4
              local.get 1
              i32.load offset=12
              i32.store
              i32.const 0
              local.set 0
              br 2 (;@3;)
            end
            local.get 6
            i32.const 16
            i32.shl
            local.tee 6
            local.get 6
            local.get 0
            i32.const -65536
            i32.and
            i32.add
            i32.const 2
            i32.or
            i32.store
            i32.const 0
            local.set 0
            local.get 6
            i32.const 0
            i32.store offset=4
            local.get 6
            local.get 1
            i32.load offset=12
            i32.store offset=8
            local.get 1
            local.get 6
            i32.store offset=12
            local.get 5
            i32.const 4
            local.get 1
            i32.const 12
            i32.add
            i32.const 1
            i32.const 65788
            call $_ZN9wee_alloc15alloc_first_fit17h2958d0738bb374faE.llvm.1804655379480408609
            local.set 6
            local.get 4
            local.get 1
            i32.load offset=12
            i32.store
            local.get 6
            i32.eqz
            br_if 1 (;@3;)
          end
          local.get 6
          i32.const 0
          i32.store offset=4
          local.get 6
          local.get 1
          i32.load offset=8
          i32.store offset=8
          local.get 6
          local.get 6
          local.get 7
          i32.add
          i32.const 2
          i32.or
          i32.store
          local.get 1
          local.get 6
          i32.store offset=8
          local.get 3
          i32.const 1
          local.get 1
          i32.const 8
          i32.add
          local.get 1
          i32.const 4
          i32.add
          i32.const 65740
          call $_ZN9wee_alloc15alloc_first_fit17h2958d0738bb374faE.llvm.1804655379480408609
          local.set 0
        end
        local.get 2
        local.get 1
        i32.load offset=8
        i32.store
        br 1 (;@1;)
      end
      local.get 1
      i32.const 0
      i32.load offset=65812
      i32.store offset=12
      block  ;; label = @2
        local.get 3
        i32.const 1
        local.get 1
        i32.const 12
        i32.add
        i32.const 65625
        i32.const 65764
        call $_ZN9wee_alloc15alloc_first_fit17h2958d0738bb374faE.llvm.1804655379480408609
        local.tee 0
        br_if 0 (;@2;)
        i32.const 0
        local.set 0
        local.get 2
        i32.const -4
        i32.and
        local.tee 2
        i32.const 16392
        local.get 2
        i32.const 16392
        i32.gt_u
        select
        i32.const 65543
        i32.add
        local.tee 2
        i32.const 16
        i32.shr_u
        memory.grow
        local.tee 6
        i32.const -1
        i32.eq
        br_if 0 (;@2;)
        local.get 6
        i32.const 16
        i32.shl
        local.tee 0
        local.get 0
        local.get 2
        i32.const -65536
        i32.and
        i32.add
        i32.const 2
        i32.or
        i32.store
        local.get 0
        i32.const 0
        i32.store offset=4
        local.get 0
        local.get 1
        i32.load offset=12
        i32.store offset=8
        local.get 1
        local.get 0
        i32.store offset=12
        local.get 3
        i32.const 1
        local.get 1
        i32.const 12
        i32.add
        i32.const 65625
        i32.const 65764
        call $_ZN9wee_alloc15alloc_first_fit17h2958d0738bb374faE.llvm.1804655379480408609
        local.set 0
      end
      i32.const 0
      local.get 1
      i32.load offset=12
      i32.store offset=65812
    end
    local.get 1
    i32.const 16
    i32.add
    global.set 0
    local.get 0)
  (func $__rg_dealloc (type 4) (param i32 i32)
    (local i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 2
      local.get 0
      i32.store offset=4
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 1
        i32.const 3
        i32.add
        i32.const 2
        i32.shr_u
        i32.const -1
        i32.add
        local.tee 0
        i32.const 255
        i32.gt_u
        br_if 0 (;@2;)
        local.get 2
        i32.const 65812
        i32.store offset=8
        local.get 2
        local.get 0
        i32.const 2
        i32.shl
        i32.const 65816
        i32.add
        local.tee 0
        i32.load
        i32.store offset=12
        local.get 2
        i32.const 4
        i32.add
        local.get 2
        i32.const 12
        i32.add
        local.get 2
        i32.const 8
        i32.add
        i32.const 65740
        call $_ZN9wee_alloc8WeeAlloc12dealloc_impl28_$u7b$$u7b$closure$u7d$$u7d$17hdfb5b4eccc8c4dccE
        local.get 0
        local.get 2
        i32.load offset=12
        i32.store
        br 1 (;@1;)
      end
      local.get 2
      i32.const 0
      i32.load offset=65812
      i32.store offset=12
      local.get 2
      i32.const 4
      i32.add
      local.get 2
      i32.const 12
      i32.add
      i32.const 65625
      i32.const 65764
      call $_ZN9wee_alloc8WeeAlloc12dealloc_impl28_$u7b$$u7b$closure$u7d$$u7d$17hdfb5b4eccc8c4dccE
      i32.const 0
      local.get 2
      i32.load offset=12
      i32.store offset=65812
    end
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func $_ZN9wee_alloc8WeeAlloc12dealloc_impl28_$u7b$$u7b$closure$u7d$$u7d$17hdfb5b4eccc8c4dccE (type 5) (param i32 i32 i32 i32)
    (local i32 i32)
    local.get 0
    i32.load
    local.tee 4
    i32.const 0
    i32.store
    local.get 4
    i32.const -8
    i32.add
    local.tee 0
    local.get 0
    i32.load
    i32.const -2
    i32.and
    i32.store
    block  ;; label = @1
      local.get 2
      local.get 3
      i32.load offset=20
      call_indirect (type 0)
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 4
          i32.const -4
          i32.add
          local.tee 3
          i32.load
          i32.const -4
          i32.and
          local.tee 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 2
          i32.load
          local.tee 5
          i32.const 1
          i32.and
          i32.eqz
          br_if 1 (;@2;)
        end
        local.get 0
        i32.load
        local.tee 2
        i32.const -4
        i32.and
        local.tee 3
        i32.eqz
        br_if 1 (;@1;)
        local.get 2
        i32.const 2
        i32.and
        br_if 1 (;@1;)
        local.get 3
        i32.load8_u
        i32.const 1
        i32.and
        br_if 1 (;@1;)
        local.get 4
        local.get 3
        i32.load offset=8
        i32.const -4
        i32.and
        i32.store
        local.get 3
        local.get 0
        i32.const 1
        i32.or
        i32.store offset=8
        return
      end
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load
            local.tee 1
            i32.const -4
            i32.and
            local.tee 4
            br_if 0 (;@4;)
            local.get 2
            local.set 1
            br 1 (;@3;)
          end
          block  ;; label = @4
            local.get 1
            i32.const 2
            i32.and
            i32.eqz
            br_if 0 (;@4;)
            local.get 2
            local.set 1
            br 1 (;@3;)
          end
          local.get 4
          local.get 4
          i32.load offset=4
          i32.const 3
          i32.and
          local.get 2
          i32.or
          i32.store offset=4
          local.get 3
          i32.load
          local.tee 4
          i32.const -4
          i32.and
          local.tee 1
          i32.eqz
          br_if 1 (;@2;)
          local.get 0
          i32.load
          i32.const -4
          i32.and
          local.set 4
          local.get 1
          i32.load
          local.set 5
        end
        local.get 1
        local.get 5
        i32.const 3
        i32.and
        local.get 4
        i32.or
        i32.store
        local.get 3
        i32.load
        local.set 4
      end
      local.get 3
      local.get 4
      i32.const 3
      i32.and
      i32.store
      local.get 0
      local.get 0
      i32.load
      local.tee 4
      i32.const 3
      i32.and
      i32.store
      block  ;; label = @2
        local.get 4
        i32.const 2
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        local.get 2
        i32.load
        i32.const 2
        i32.or
        i32.store
      end
      return
    end
    local.get 4
    local.get 1
    i32.load
    i32.store
    local.get 1
    local.get 0
    i32.store)
  (func $_ZN4core9panicking9panic_fmt17h208bc982e6cfe835E (type 7)
    unreachable
    unreachable)
  (func $_ZN70_$LT$wee_alloc..LargeAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$22new_cell_for_free_list17h42f7fb54ef6be16cE (type 5) (param i32 i32 i32 i32)
    (local i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.const 2
        i32.shl
        local.tee 2
        local.get 3
        i32.const 3
        i32.shl
        i32.const 16384
        i32.add
        local.tee 3
        local.get 2
        local.get 3
        i32.gt_u
        select
        i32.const 65543
        i32.add
        local.tee 4
        i32.const 16
        i32.shr_u
        memory.grow
        local.tee 3
        i32.const -1
        i32.ne
        br_if 0 (;@2;)
        i32.const 1
        local.set 2
        i32.const 0
        local.set 3
        br 1 (;@1;)
      end
      local.get 3
      i32.const 16
      i32.shl
      local.tee 3
      i64.const 0
      i64.store
      i32.const 0
      local.set 2
      local.get 3
      i32.const 0
      i32.store offset=8
      local.get 3
      local.get 3
      local.get 4
      i32.const -65536
      i32.and
      i32.add
      i32.const 2
      i32.or
      i32.store
    end
    local.get 0
    local.get 3
    i32.store offset=4
    local.get 0
    local.get 2
    i32.store)
  (func $_ZN70_$LT$wee_alloc..LargeAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$13min_cell_size17h0c0e4c4ac7e0c29cE (type 1) (param i32 i32) (result i32)
    i32.const 512)
  (func $_ZN70_$LT$wee_alloc..LargeAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$32should_merge_adjacent_free_cells17h9d94f9e9f41ec656E (type 0) (param i32) (result i32)
    i32.const 1)
  (func $_ZN9wee_alloc15alloc_first_fit17h2958d0738bb374faE.llvm.1804655379480408609 (type 8) (param i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.load
        local.tee 5
        i32.eqz
        br_if 0 (;@2;)
        local.get 1
        i32.const -1
        i32.add
        local.set 6
        local.get 0
        i32.const 2
        i32.shl
        local.set 7
        i32.const 0
        local.get 1
        i32.sub
        local.set 8
        loop  ;; label = @3
          local.get 5
          i32.const 8
          i32.add
          local.set 9
          block  ;; label = @4
            local.get 5
            i32.load offset=8
            local.tee 10
            i32.const 1
            i32.and
            i32.eqz
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 9
              local.get 10
              i32.const -2
              i32.and
              i32.store
              block  ;; label = @6
                block  ;; label = @7
                  local.get 5
                  i32.load offset=4
                  local.tee 10
                  i32.const -4
                  i32.and
                  local.tee 9
                  br_if 0 (;@7;)
                  i32.const 0
                  local.set 1
                  br 1 (;@6;)
                end
                i32.const 0
                local.get 9
                local.get 9
                i32.load8_u
                i32.const 1
                i32.and
                select
                local.set 1
              end
              block  ;; label = @6
                local.get 5
                i32.load
                local.tee 11
                i32.const -4
                i32.and
                local.tee 12
                i32.eqz
                br_if 0 (;@6;)
                local.get 11
                i32.const 2
                i32.and
                br_if 0 (;@6;)
                local.get 12
                local.get 12
                i32.load offset=4
                i32.const 3
                i32.and
                local.get 9
                i32.or
                i32.store offset=4
                local.get 5
                i32.load offset=4
                local.tee 10
                i32.const -4
                i32.and
                local.set 9
              end
              block  ;; label = @6
                local.get 9
                i32.eqz
                br_if 0 (;@6;)
                local.get 9
                local.get 9
                i32.load
                i32.const 3
                i32.and
                local.get 5
                i32.load
                i32.const -4
                i32.and
                i32.or
                i32.store
                local.get 5
                i32.load offset=4
                local.set 10
              end
              local.get 5
              local.get 10
              i32.const 3
              i32.and
              i32.store offset=4
              local.get 5
              local.get 5
              i32.load
              local.tee 9
              i32.const 3
              i32.and
              i32.store
              block  ;; label = @6
                local.get 9
                i32.const 2
                i32.and
                i32.eqz
                br_if 0 (;@6;)
                local.get 1
                local.get 1
                i32.load
                i32.const 2
                i32.or
                i32.store
              end
              local.get 2
              local.get 1
              i32.store
              local.get 1
              i32.const 8
              i32.add
              local.set 9
              local.get 1
              local.set 5
              local.get 1
              i32.load offset=8
              local.tee 10
              i32.const 1
              i32.and
              br_if 0 (;@5;)
            end
            local.get 1
            local.set 5
          end
          block  ;; label = @4
            local.get 5
            i32.load
            i32.const -4
            i32.and
            local.tee 1
            local.get 9
            i32.sub
            local.get 7
            i32.lt_u
            br_if 0 (;@4;)
            block  ;; label = @5
              local.get 9
              local.get 3
              local.get 0
              local.get 4
              i32.load offset=16
              call_indirect (type 1)
              i32.const 2
              i32.shl
              i32.add
              i32.const 8
              i32.add
              local.get 1
              local.get 7
              i32.sub
              local.get 8
              i32.and
              local.tee 1
              i32.le_u
              br_if 0 (;@5;)
              local.get 6
              local.get 9
              i32.and
              br_if 1 (;@4;)
              local.get 2
              local.get 9
              i32.load
              i32.const -4
              i32.and
              i32.store
              local.get 5
              local.set 1
              br 4 (;@1;)
            end
            local.get 1
            i32.const 0
            i32.store
            local.get 1
            i32.const -8
            i32.add
            local.tee 1
            i64.const 0
            i64.store align=4
            local.get 1
            local.get 5
            i32.load
            i32.const -4
            i32.and
            i32.store
            block  ;; label = @5
              local.get 5
              i32.load
              local.tee 12
              i32.const -4
              i32.and
              local.tee 10
              i32.eqz
              br_if 0 (;@5;)
              local.get 12
              i32.const 2
              i32.and
              br_if 0 (;@5;)
              local.get 10
              local.get 10
              i32.load offset=4
              i32.const 3
              i32.and
              local.get 1
              i32.or
              i32.store offset=4
            end
            local.get 1
            local.get 1
            i32.load offset=4
            i32.const 3
            i32.and
            local.get 5
            i32.or
            i32.store offset=4
            local.get 5
            local.get 5
            i32.load
            i32.const 3
            i32.and
            local.get 1
            i32.or
            i32.store
            local.get 9
            local.get 9
            i32.load
            i32.const -2
            i32.and
            i32.store
            local.get 5
            i32.load
            local.tee 9
            i32.const 2
            i32.and
            i32.eqz
            br_if 3 (;@1;)
            local.get 5
            local.get 9
            i32.const -3
            i32.and
            i32.store
            local.get 1
            local.get 1
            i32.load
            i32.const 2
            i32.or
            i32.store
            br 3 (;@1;)
          end
          local.get 2
          local.get 5
          i32.load offset=8
          local.tee 5
          i32.store
          local.get 5
          br_if 0 (;@3;)
        end
      end
      i32.const 0
      return
    end
    local.get 1
    local.get 1
    i32.load
    i32.const 1
    i32.or
    i32.store
    local.get 1
    i32.const 8
    i32.add)
  (func $_ZN4core3ptr18real_drop_in_place17hd173886e09796329E (type 6) (param i32))
  (func $_ZN4core3ptr18real_drop_in_place17h062cda866a759cd0E (type 6) (param i32))
  (func $_ZN88_$LT$wee_alloc..size_classes..SizeClassAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$22new_cell_for_free_list17h9a4ed9b46a4acff7E (type 5) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 4
    global.set 0
    local.get 4
    local.get 1
    i32.load
    local.tee 5
    i32.load
    i32.store offset=12
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.const 2
          i32.add
          local.tee 2
          local.get 2
          i32.mul
          local.tee 2
          i32.const 2048
          local.get 2
          i32.const 2048
          i32.gt_u
          select
          local.tee 1
          i32.const 4
          local.get 4
          i32.const 12
          i32.add
          i32.const 1
          i32.const 65788
          call $_ZN9wee_alloc15alloc_first_fit17h2958d0738bb374faE.llvm.1804655379480408609
          local.tee 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 5
          local.get 4
          i32.load offset=12
          i32.store
          local.get 1
          i32.const 2
          i32.shl
          local.set 6
          br 1 (;@2;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 1
            i32.const 2
            i32.shl
            local.tee 6
            i32.const 16416
            local.get 6
            i32.const 16416
            i32.gt_u
            select
            i32.const 65543
            i32.add
            local.tee 7
            i32.const 16
            i32.shr_u
            memory.grow
            local.tee 2
            i32.const -1
            i32.ne
            br_if 0 (;@4;)
            local.get 5
            local.get 4
            i32.load offset=12
            i32.store
            i32.const 1
            local.set 7
            br 1 (;@3;)
          end
          local.get 2
          i32.const 16
          i32.shl
          local.tee 2
          local.get 2
          local.get 7
          i32.const -65536
          i32.and
          i32.add
          i32.const 2
          i32.or
          i32.store
          local.get 2
          i32.const 0
          i32.store offset=4
          local.get 2
          local.get 4
          i32.load offset=12
          i32.store offset=8
          local.get 4
          local.get 2
          i32.store offset=12
          i32.const 1
          local.set 7
          local.get 1
          i32.const 4
          local.get 4
          i32.const 12
          i32.add
          i32.const 1
          i32.const 65788
          call $_ZN9wee_alloc15alloc_first_fit17h2958d0738bb374faE.llvm.1804655379480408609
          local.set 2
          local.get 5
          local.get 4
          i32.load offset=12
          i32.store
          local.get 2
          br_if 1 (;@2;)
        end
        br 1 (;@1;)
      end
      local.get 2
      i64.const 0
      i64.store offset=4 align=4
      local.get 2
      local.get 2
      local.get 6
      i32.add
      i32.const 2
      i32.or
      i32.store
      i32.const 0
      local.set 7
    end
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 0
    local.get 7
    i32.store
    local.get 4
    i32.const 16
    i32.add
    global.set 0)
  (func $_ZN88_$LT$wee_alloc..size_classes..SizeClassAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$13min_cell_size17h19259326bbc840afE (type 1) (param i32 i32) (result i32)
    local.get 1)
  (func $_ZN88_$LT$wee_alloc..size_classes..SizeClassAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$32should_merge_adjacent_free_cells17hcd1726812e076be6E (type 0) (param i32) (result i32)
    i32.const 0)
  (func $memcpy (type 9) (param i32 i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.set 3
      loop  ;; label = @2
        local.get 3
        local.get 1
        i32.load8_u
        i32.store8
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        local.get 2
        i32.const -1
        i32.add
        local.tee 2
        br_if 0 (;@2;)
      end
    end
    local.get 0)
  (table (;0;) 9 9 funcref)
  (global (;0;) (mut i32) (i32.const 65536))
  (global (;1;) i32 (i32.const 66840))
  (global (;2;) i32 (i32.const 66840))
  (export "__data_end" (global 1))
  (export "__heap_base" (global 2))
  (export "call" (func $call))
  (export "deploy" (func $deploy))
  (elem (;0;) (i32.const 1) $_ZN4core3ptr18real_drop_in_place17h062cda866a759cd0E $_ZN88_$LT$wee_alloc..size_classes..SizeClassAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$22new_cell_for_free_list17h9a4ed9b46a4acff7E $_ZN88_$LT$wee_alloc..size_classes..SizeClassAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$13min_cell_size17h19259326bbc840afE $_ZN88_$LT$wee_alloc..size_classes..SizeClassAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$32should_merge_adjacent_free_cells17hcd1726812e076be6E $_ZN4core3ptr18real_drop_in_place17hd173886e09796329E $_ZN70_$LT$wee_alloc..LargeAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$22new_cell_for_free_list17h42f7fb54ef6be16cE $_ZN70_$LT$wee_alloc..LargeAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$13min_cell_size17h0c0e4c4ac7e0c29cE $_ZN70_$LT$wee_alloc..LargeAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$32should_merge_adjacent_free_cells17h9d94f9e9f41ec656E)
  (data (;0;) (i32.const 65536) "\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01\01self-evictgetincH\00\01\00\11\00\00\00\b4\00\01\00\17\00\00\00\09\03\00\00\05\00\00\00capacity overflow\00\00\00t\00\01\00+\00\00\00\9f\00\01\00\15\00\00\00z\01\00\00\15\00\00\00called `Option::unwrap()` on a `None` valuesrc/libcore/option.rssrc/liballoc/raw_vec.rs\00\01\00\00\00\04\00\00\00\04\00\00\00\02\00\00\00\03\00\00\00\04\00\00\00\05\00\00\00\00\00\00\00\01\00\00\00\06\00\00\00\07\00\00\00\08\00\00\00\05\00\00\00\00\00\00\00\01\00\00\00\06\00\00\00\07\00\00\00\08\00\00\00")
  (data (;1;) (i32.const 65812) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"))
