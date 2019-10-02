(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (param i32 i32) (result i32)))
  (type (;2;) (func (result i32)))
  (type (;3;) (func (param i32 i32 i32)))
  (type (;4;) (func (param i32 i32 i32 i32)))
  (type (;5;) (func (param i32 i32 i32 i32 i32 i32 i32 i32)))
  (type (;6;) (func (param i32 i32)))
  (type (;7;) (func))
  (type (;8;) (func (param i32)))
  (type (;9;) (func (param i32 i32 i32) (result i32)))
  (type (;10;) (func (param i32 i32 i32 i32 i32) (result i32)))
  (import "env" "memory" (memory (;0;) 2 16))
  (import "env" "ext_scratch_size" (func $ext_scratch_size (type 2)))
  (import "env" "ext_scratch_read" (func $ext_scratch_read (type 3)))
  (import "env" "ext_get_storage" (func $ext_get_storage (type 0)))
  (import "env" "ext_set_storage" (func $ext_set_storage (type 4)))
  (import "env" "ext_restore_to" (func $ext_restore_to (type 5)))
  (import "env" "ext_scratch_write" (func $ext_scratch_write (type 6)))
  (import "env" "ext_caller" (func $ext_caller (type 7)))
  (func $rust_oom (type 6) (param i32 i32)
    unreachable
    unreachable)
  (func $call (type 2) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64 i64 i32 i32 i64 i64 i64 i64)
    global.get 0
    i32.const 336
    i32.sub
    local.tee 0
    global.set 0
    block  ;; label = @1
      block  ;; label = @2
        call $ext_scratch_size
        local.tee 1
        br_if 0 (;@2;)
        i32.const 1
        local.set 2
        i32.const 0
        local.set 1
        i32.const 0
        local.set 3
        br 1 (;@1;)
      end
      local.get 0
      i32.const 0
      i32.store offset=304
      local.get 0
      i64.const 1
      i64.store offset=296
      local.get 0
      i32.const 296
      i32.add
      local.get 1
      call $_ZN5alloc3vec12Vec$LT$T$GT$6resize17hb64dac7d6b3d3a8bE
      local.get 0
      i32.load offset=296
      local.tee 2
      i32.const 0
      local.get 1
      call $ext_scratch_read
      local.get 0
      i32.load offset=304
      local.set 1
      local.get 0
      i32.load offset=300
      local.set 3
    end
    local.get 0
    i32.const 0
    i32.store8 offset=296
    local.get 0
    i32.const 296
    i32.add
    local.get 2
    local.get 1
    i32.const 0
    i32.ne
    local.tee 4
    call $memcpy
    drop
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 1
                    local.get 4
                    i32.lt_u
                    br_if 0 (;@8;)
                    local.get 1
                    i32.eqz
                    br_if 7 (;@1;)
                    local.get 0
                    i32.load8_u offset=296
                    local.tee 5
                    i32.const 1
                    i32.gt_u
                    br_if 7 (;@1;)
                    local.get 1
                    local.get 4
                    i32.sub
                    local.set 1
                    local.get 2
                    local.get 4
                    i32.add
                    local.set 4
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          local.get 5
                          br_table 0 (;@11;) 1 (;@10;) 0 (;@11;)
                        end
                        i32.const 0
                        local.set 6
                        local.get 0
                        i32.const 296
                        i32.add
                        local.get 1
                        i32.const 32
                        local.get 1
                        i32.const 32
                        i32.lt_u
                        local.tee 7
                        select
                        local.tee 5
                        i32.add
                        i32.const 0
                        i32.const 0
                        i32.const 32
                        local.get 5
                        i32.sub
                        local.get 5
                        i32.const 31
                        i32.gt_u
                        select
                        call $memset
                        drop
                        local.get 0
                        i32.const 296
                        i32.add
                        local.get 4
                        local.get 5
                        call $memcpy
                        drop
                        block  ;; label = @11
                          local.get 7
                          br_if 0 (;@11;)
                          local.get 0
                          i32.const 232
                          i32.add
                          i32.const 24
                          i32.add
                          local.get 0
                          i32.const 296
                          i32.add
                          i32.const 24
                          i32.add
                          i64.load align=1
                          i64.store
                          local.get 0
                          i32.const 232
                          i32.add
                          i32.const 16
                          i32.add
                          local.get 0
                          i32.const 296
                          i32.add
                          i32.const 16
                          i32.add
                          i64.load align=1
                          i64.store
                          local.get 0
                          i32.const 232
                          i32.add
                          i32.const 8
                          i32.add
                          local.get 0
                          i32.const 296
                          i32.add
                          i32.const 8
                          i32.add
                          i64.load align=1
                          i64.store
                          local.get 0
                          local.get 0
                          i64.load offset=296 align=1
                          i64.store offset=232
                          i32.const 1
                          local.set 6
                        end
                        local.get 0
                        i32.const 264
                        i32.add
                        i32.const 24
                        i32.add
                        local.tee 7
                        local.get 0
                        i32.const 232
                        i32.add
                        i32.const 24
                        i32.add
                        i64.load
                        i64.store
                        local.get 0
                        i32.const 264
                        i32.add
                        i32.const 16
                        i32.add
                        local.tee 8
                        local.get 0
                        i32.const 232
                        i32.add
                        i32.const 16
                        i32.add
                        i64.load
                        i64.store
                        local.get 0
                        i32.const 264
                        i32.add
                        i32.const 8
                        i32.add
                        local.tee 9
                        local.get 0
                        i32.const 232
                        i32.add
                        i32.const 8
                        i32.add
                        i64.load
                        i64.store
                        local.get 0
                        local.get 0
                        i64.load offset=232
                        i64.store offset=264
                        local.get 6
                        i32.eqz
                        br_if 9 (;@1;)
                        local.get 0
                        i32.const 200
                        i32.add
                        i32.const 24
                        i32.add
                        local.get 7
                        i64.load
                        i64.store
                        local.get 0
                        i32.const 200
                        i32.add
                        i32.const 16
                        i32.add
                        local.get 8
                        i64.load
                        i64.store
                        local.get 0
                        i32.const 200
                        i32.add
                        i32.const 8
                        i32.add
                        local.get 9
                        i64.load
                        i64.store
                        local.get 0
                        local.get 0
                        i64.load offset=264
                        i64.store offset=200
                        local.get 0
                        i32.const 0
                        i32.store8 offset=296
                        local.get 0
                        i32.const 296
                        i32.add
                        local.get 4
                        local.get 5
                        i32.add
                        local.tee 7
                        local.get 1
                        local.get 5
                        i32.sub
                        local.tee 1
                        i32.const 0
                        i32.ne
                        local.tee 4
                        call $memcpy
                        drop
                        local.get 1
                        local.get 4
                        i32.lt_u
                        br_if 3 (;@7;)
                        local.get 1
                        i32.eqz
                        br_if 9 (;@1;)
                        local.get 0
                        i32.load8_u offset=296
                        local.tee 6
                        i32.const 1
                        i32.gt_u
                        br_if 9 (;@1;)
                        i32.const 0
                        local.set 5
                        block  ;; label = @11
                          block  ;; label = @12
                            local.get 6
                            br_table 1 (;@11;) 0 (;@12;) 1 (;@11;)
                          end
                          local.get 0
                          i32.const 0
                          i32.store8 offset=296
                          local.get 0
                          i32.const 296
                          i32.add
                          local.get 7
                          local.get 4
                          i32.add
                          local.tee 5
                          local.get 1
                          local.get 4
                          i32.sub
                          local.tee 1
                          i32.const 0
                          i32.ne
                          local.tee 4
                          call $memcpy
                          drop
                          local.get 1
                          local.get 4
                          i32.lt_u
                          br_if 5 (;@6;)
                          local.get 1
                          i32.eqz
                          br_if 10 (;@1;)
                          local.get 1
                          local.get 4
                          i32.sub
                          local.set 1
                          local.get 5
                          local.get 4
                          i32.add
                          local.set 6
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                local.get 0
                                i32.load8_u offset=296
                                local.tee 4
                                i32.const 3
                                i32.and
                                local.tee 5
                                i32.const 3
                                i32.eq
                                br_if 0 (;@14;)
                                block  ;; label = @15
                                  block  ;; label = @16
                                    local.get 5
                                    br_table 3 (;@13;) 0 (;@16;) 1 (;@15;) 3 (;@13;)
                                  end
                                  local.get 0
                                  i32.const 0
                                  i32.store8 offset=296
                                  local.get 0
                                  i32.const 296
                                  i32.add
                                  local.get 6
                                  local.get 1
                                  i32.const 0
                                  i32.ne
                                  local.tee 5
                                  call $memcpy
                                  drop
                                  local.get 1
                                  local.get 5
                                  i32.lt_u
                                  br_if 10 (;@5;)
                                  local.get 1
                                  i32.eqz
                                  br_if 14 (;@1;)
                                  local.get 1
                                  local.get 5
                                  i32.sub
                                  local.set 1
                                  local.get 6
                                  local.get 5
                                  i32.add
                                  local.set 6
                                  local.get 0
                                  i32.load8_u offset=296
                                  i32.const 8
                                  i32.shl
                                  local.get 4
                                  i32.or
                                  i32.const 2
                                  i32.shr_u
                                  local.set 4
                                  local.get 0
                                  i32.const 296
                                  i32.add
                                  local.set 8
                                  br 3 (;@12;)
                                end
                                local.get 0
                                i32.const 0
                                i32.store8 offset=334
                                local.get 0
                                i32.const 0
                                i32.store16 offset=332
                                local.get 0
                                i32.const 332
                                i32.add
                                local.get 6
                                local.get 1
                                i32.const 3
                                local.get 1
                                i32.const 3
                                i32.lt_u
                                local.tee 7
                                select
                                local.tee 5
                                call $memcpy
                                drop
                                local.get 7
                                br_if 13 (;@1;)
                                local.get 1
                                local.get 5
                                i32.sub
                                local.set 1
                                local.get 6
                                local.get 5
                                i32.add
                                local.set 6
                                local.get 0
                                i32.load16_u offset=332
                                local.get 0
                                i32.load8_u offset=334
                                i32.const 16
                                i32.shl
                                i32.or
                                i32.const 8
                                i32.shl
                                local.get 4
                                i32.or
                                i32.const 2
                                i32.shr_u
                                local.set 4
                                local.get 0
                                i32.const 296
                                i32.add
                                local.set 8
                                br 2 (;@12;)
                              end
                              local.get 4
                              i32.const 3
                              i32.gt_u
                              br_if 12 (;@1;)
                              local.get 0
                              i32.const 0
                              i32.store offset=296
                              local.get 0
                              i32.const 296
                              i32.add
                              local.get 6
                              local.get 1
                              i32.const 4
                              local.get 1
                              i32.const 4
                              i32.lt_u
                              select
                              local.tee 5
                              call $memcpy
                              drop
                              local.get 1
                              i32.const 3
                              i32.le_u
                              br_if 12 (;@1;)
                              block  ;; label = @14
                                local.get 0
                                i32.load offset=296
                                local.tee 4
                                i32.const -1
                                i32.le_s
                                br_if 0 (;@14;)
                                local.get 1
                                local.get 5
                                i32.sub
                                local.set 1
                                local.get 6
                                local.get 5
                                i32.add
                                local.set 6
                                local.get 0
                                i32.const 296
                                i32.add
                                local.set 8
                                br 2 (;@12;)
                              end
                              call $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$11allocate_in28_$u7b$$u7b$closure$u7d$$u7d$17hb4614da3fb236ccdE
                              unreachable
                            end
                            local.get 4
                            i32.const 2
                            i32.shr_u
                            local.set 4
                            local.get 0
                            i32.const 296
                            i32.add
                            local.set 8
                          end
                          block  ;; label = @12
                            block  ;; label = @13
                              local.get 4
                              br_if 0 (;@13;)
                              i32.const 1
                              local.set 5
                              i32.const 0
                              local.set 7
                              br 1 (;@12;)
                            end
                            local.get 4
                            local.set 7
                            local.get 4
                            call $__rust_alloc_zeroed
                            local.tee 5
                            i32.eqz
                            br_if 8 (;@4;)
                          end
                          local.get 0
                          local.get 7
                          i32.store offset=304
                          local.get 0
                          local.get 7
                          i32.store offset=300
                          local.get 0
                          local.get 5
                          i32.store offset=296
                          local.get 5
                          local.get 6
                          local.get 1
                          local.get 4
                          local.get 1
                          local.get 4
                          i32.lt_u
                          select
                          call $memcpy
                          local.set 4
                          block  ;; label = @12
                            local.get 7
                            local.get 1
                            i32.le_u
                            br_if 0 (;@12;)
                            local.get 4
                            local.get 7
                            call $__rust_dealloc
                            br 11 (;@1;)
                          end
                          local.get 4
                          i32.eqz
                          br_if 10 (;@1;)
                          local.get 8
                          i64.load offset=4 align=4
                          local.set 10
                        end
                        local.get 0
                        i32.const 296
                        i32.add
                        i32.const 24
                        i32.add
                        local.get 0
                        i32.const 200
                        i32.add
                        i32.const 24
                        i32.add
                        i64.load
                        i64.store
                        local.get 0
                        i32.const 296
                        i32.add
                        i32.const 16
                        i32.add
                        local.get 0
                        i32.const 200
                        i32.add
                        i32.const 16
                        i32.add
                        i64.load
                        i64.store
                        local.get 0
                        i32.const 296
                        i32.add
                        i32.const 8
                        i32.add
                        local.get 0
                        i32.const 200
                        i32.add
                        i32.const 8
                        i32.add
                        i64.load
                        i64.store
                        local.get 0
                        i32.const 232
                        i32.add
                        i32.const 2
                        i32.add
                        local.get 0
                        i32.const 136
                        i32.add
                        i32.const 2
                        i32.add
                        i32.load8_u
                        i32.store8
                        local.get 0
                        i32.const 264
                        i32.add
                        i32.const 8
                        i32.add
                        local.get 0
                        i32.const 168
                        i32.add
                        i32.const 8
                        i32.add
                        i64.load
                        i64.store
                        local.get 0
                        i32.const 264
                        i32.add
                        i32.const 16
                        i32.add
                        local.get 0
                        i32.const 168
                        i32.add
                        i32.const 16
                        i32.add
                        i64.load
                        i64.store
                        local.get 0
                        local.get 0
                        i64.load offset=200
                        i64.store offset=296
                        local.get 0
                        local.get 0
                        i32.load16_u offset=136 align=1
                        i32.store16 offset=232
                        local.get 0
                        local.get 0
                        i64.load offset=168
                        i64.store offset=264
                        i32.const 0
                        local.set 6
                        br 1 (;@9;)
                      end
                      i32.const 0
                      local.set 6
                      local.get 0
                      i32.const 296
                      i32.add
                      local.get 1
                      i32.const 32
                      local.get 1
                      i32.const 32
                      i32.lt_u
                      local.tee 7
                      select
                      local.tee 5
                      i32.add
                      i32.const 0
                      i32.const 0
                      i32.const 32
                      local.get 5
                      i32.sub
                      local.get 5
                      i32.const 31
                      i32.gt_u
                      select
                      call $memset
                      drop
                      local.get 0
                      i32.const 296
                      i32.add
                      local.get 4
                      local.get 5
                      call $memcpy
                      drop
                      block  ;; label = @10
                        local.get 7
                        br_if 0 (;@10;)
                        local.get 0
                        i32.const 232
                        i32.add
                        i32.const 24
                        i32.add
                        local.get 0
                        i32.const 296
                        i32.add
                        i32.const 24
                        i32.add
                        i64.load align=1
                        i64.store
                        local.get 0
                        i32.const 232
                        i32.add
                        i32.const 16
                        i32.add
                        local.get 0
                        i32.const 296
                        i32.add
                        i32.const 16
                        i32.add
                        i64.load align=1
                        i64.store
                        local.get 0
                        i32.const 232
                        i32.add
                        i32.const 8
                        i32.add
                        local.get 0
                        i32.const 296
                        i32.add
                        i32.const 8
                        i32.add
                        i64.load align=1
                        i64.store
                        local.get 0
                        local.get 0
                        i64.load offset=296 align=1
                        i64.store offset=232
                        i32.const 1
                        local.set 6
                      end
                      local.get 0
                      i32.const 264
                      i32.add
                      i32.const 24
                      i32.add
                      local.tee 7
                      local.get 0
                      i32.const 232
                      i32.add
                      i32.const 24
                      i32.add
                      i64.load
                      i64.store
                      local.get 0
                      i32.const 264
                      i32.add
                      i32.const 16
                      i32.add
                      local.tee 8
                      local.get 0
                      i32.const 232
                      i32.add
                      i32.const 16
                      i32.add
                      i64.load
                      i64.store
                      local.get 0
                      i32.const 264
                      i32.add
                      i32.const 8
                      i32.add
                      local.tee 9
                      local.get 0
                      i32.const 232
                      i32.add
                      i32.const 8
                      i32.add
                      i64.load
                      i64.store
                      local.get 0
                      local.get 0
                      i64.load offset=232
                      i64.store offset=264
                      local.get 6
                      i32.eqz
                      br_if 8 (;@1;)
                      local.get 0
                      i32.const 168
                      i32.add
                      i32.const 24
                      i32.add
                      local.get 7
                      i64.load
                      i64.store
                      local.get 0
                      i32.const 168
                      i32.add
                      i32.const 16
                      i32.add
                      local.get 8
                      i64.load
                      i64.store
                      local.get 0
                      i32.const 168
                      i32.add
                      i32.const 8
                      i32.add
                      local.get 9
                      i64.load
                      i64.store
                      local.get 0
                      local.get 0
                      i64.load offset=264
                      i64.store offset=168
                      local.get 0
                      i32.const 296
                      i32.add
                      local.get 1
                      local.get 5
                      i32.sub
                      local.tee 6
                      i32.const 32
                      local.get 6
                      i32.const 32
                      i32.lt_u
                      local.tee 7
                      select
                      local.tee 1
                      i32.add
                      i32.const 0
                      i32.const 0
                      i32.const 32
                      local.get 1
                      i32.sub
                      local.get 1
                      i32.const 31
                      i32.gt_u
                      select
                      call $memset
                      drop
                      local.get 0
                      i32.const 296
                      i32.add
                      local.get 4
                      local.get 5
                      i32.add
                      local.tee 5
                      local.get 1
                      call $memcpy
                      drop
                      local.get 7
                      br_if 8 (;@1;)
                      local.get 0
                      i32.const 232
                      i32.add
                      i32.const 24
                      i32.add
                      local.get 0
                      i32.const 296
                      i32.add
                      i32.const 24
                      i32.add
                      local.tee 7
                      i64.load align=1
                      local.tee 10
                      i64.store
                      local.get 0
                      i32.const 232
                      i32.add
                      i32.const 16
                      i32.add
                      local.get 0
                      i32.const 296
                      i32.add
                      i32.const 16
                      i32.add
                      local.tee 8
                      i64.load align=1
                      local.tee 11
                      i64.store
                      local.get 0
                      i32.const 200
                      i32.add
                      i32.const 16
                      i32.add
                      local.tee 9
                      local.get 11
                      i64.store
                      local.get 0
                      i32.const 200
                      i32.add
                      i32.const 24
                      i32.add
                      local.tee 12
                      local.get 10
                      i64.store
                      local.get 0
                      i32.const 200
                      i32.add
                      i32.const 8
                      i32.add
                      local.tee 13
                      local.get 0
                      i32.const 296
                      i32.add
                      i32.const 8
                      i32.add
                      local.tee 4
                      i64.load align=1
                      i64.store
                      local.get 0
                      local.get 0
                      i64.load offset=296 align=1
                      i64.store offset=200
                      local.get 0
                      i64.const 0
                      i64.store offset=304
                      local.get 0
                      i64.const 0
                      i64.store offset=296
                      local.get 0
                      i32.const 296
                      i32.add
                      local.get 5
                      local.get 1
                      i32.add
                      local.get 6
                      local.get 1
                      i32.sub
                      local.tee 1
                      i32.const 16
                      local.get 1
                      i32.const 16
                      i32.lt_u
                      select
                      call $memcpy
                      drop
                      local.get 1
                      i32.const 15
                      i32.le_u
                      br_if 8 (;@1;)
                      local.get 0
                      i32.const 136
                      i32.add
                      i32.const 8
                      i32.add
                      local.tee 1
                      local.get 0
                      i32.const 168
                      i32.add
                      i32.const 8
                      i32.add
                      i64.load
                      i64.store
                      local.get 0
                      i32.const 136
                      i32.add
                      i32.const 16
                      i32.add
                      local.tee 5
                      local.get 0
                      i32.const 168
                      i32.add
                      i32.const 16
                      i32.add
                      i64.load
                      i64.store
                      local.get 0
                      i32.const 136
                      i32.add
                      i32.const 24
                      i32.add
                      local.tee 6
                      local.get 0
                      i32.const 168
                      i32.add
                      i32.const 24
                      i32.add
                      i64.load
                      i64.store
                      local.get 0
                      i32.const 104
                      i32.add
                      i32.const 8
                      i32.add
                      local.get 13
                      i64.load
                      i64.store
                      local.get 0
                      i32.const 104
                      i32.add
                      i32.const 16
                      i32.add
                      local.get 9
                      i64.load
                      i64.store
                      local.get 0
                      i32.const 104
                      i32.add
                      i32.const 24
                      i32.add
                      local.get 12
                      i64.load
                      i64.store
                      local.get 0
                      local.get 0
                      i64.load offset=168
                      i64.store offset=136
                      local.get 0
                      local.get 0
                      i64.load offset=200
                      i64.store offset=104
                      local.get 4
                      i64.load
                      local.set 14
                      local.get 0
                      i64.load offset=296
                      local.set 15
                      local.get 4
                      local.get 1
                      i64.load
                      i64.store
                      local.get 8
                      local.get 5
                      i64.load
                      i64.store
                      local.get 7
                      local.get 6
                      i64.load
                      i64.store
                      local.get 0
                      i32.const 234
                      i32.add
                      local.get 0
                      i32.load8_u offset=106
                      i32.store8
                      local.get 0
                      i32.const 264
                      i32.add
                      i32.const 8
                      i32.add
                      local.get 0
                      i32.const 127
                      i32.add
                      i64.load align=1
                      i64.store
                      local.get 0
                      i32.const 264
                      i32.add
                      i32.const 16
                      i32.add
                      local.get 0
                      i32.const 135
                      i32.add
                      i32.load8_u
                      i32.store8
                      local.get 0
                      local.get 0
                      i64.load offset=136
                      i64.store offset=296
                      local.get 0
                      local.get 0
                      i32.load16_u offset=104
                      i32.store16 offset=232
                      local.get 0
                      local.get 0
                      i64.load offset=119 align=1
                      i64.store offset=264
                      local.get 0
                      i32.load offset=107 align=1
                      local.set 5
                      local.get 0
                      i64.load offset=111 align=1
                      local.set 10
                      local.get 0
                      i32.const 284
                      i32.add
                      local.get 0
                      i32.const 43
                      i32.add
                      i32.load align=1
                      i32.store align=1
                      local.get 0
                      local.get 0
                      i32.load offset=40 align=1
                      i32.store offset=281 align=1
                      i32.const 1
                      local.set 6
                    end
                    local.get 0
                    i32.const 40
                    i32.add
                    i32.const 24
                    i32.add
                    local.tee 1
                    local.get 0
                    i32.const 296
                    i32.add
                    i32.const 24
                    i32.add
                    i64.load
                    i64.store
                    local.get 0
                    i32.const 40
                    i32.add
                    i32.const 16
                    i32.add
                    local.tee 4
                    local.get 0
                    i32.const 296
                    i32.add
                    i32.const 16
                    i32.add
                    i64.load
                    i64.store
                    local.get 0
                    i32.const 40
                    i32.add
                    i32.const 8
                    i32.add
                    local.tee 7
                    local.get 0
                    i32.const 296
                    i32.add
                    i32.const 8
                    i32.add
                    i64.load
                    i64.store
                    local.get 0
                    i32.const 36
                    i32.add
                    i32.const 2
                    i32.add
                    local.tee 8
                    local.get 0
                    i32.const 232
                    i32.add
                    i32.const 2
                    i32.add
                    i32.load8_u
                    i32.store8
                    local.get 0
                    i32.const 8
                    i32.add
                    i32.const 8
                    i32.add
                    local.tee 9
                    local.get 0
                    i32.const 264
                    i32.add
                    i32.const 8
                    i32.add
                    i64.load
                    i64.store
                    local.get 0
                    i32.const 8
                    i32.add
                    i32.const 16
                    i32.add
                    local.tee 12
                    local.get 0
                    i32.const 264
                    i32.add
                    i32.const 16
                    i32.add
                    i64.load
                    i64.store
                    local.get 0
                    local.get 0
                    i64.load offset=296
                    i64.store offset=40
                    local.get 0
                    local.get 0
                    i32.load16_u offset=232
                    i32.store16 offset=36
                    local.get 0
                    local.get 0
                    i64.load offset=264
                    i64.store offset=8
                    local.get 0
                    i32.const 232
                    i32.add
                    i32.const 8
                    i32.add
                    local.get 7
                    i64.load
                    i64.store
                    local.get 0
                    i32.const 232
                    i32.add
                    i32.const 16
                    i32.add
                    local.get 4
                    i64.load
                    i64.store
                    local.get 0
                    i32.const 232
                    i32.add
                    i32.const 24
                    i32.add
                    local.get 1
                    i64.load
                    i64.store
                    local.get 0
                    i32.const 100
                    i32.add
                    i32.const 2
                    i32.add
                    local.get 8
                    i32.load8_u
                    i32.store8
                    local.get 0
                    i32.const 72
                    i32.add
                    i32.const 8
                    i32.add
                    local.get 9
                    i64.load
                    i64.store
                    local.get 0
                    i32.const 72
                    i32.add
                    i32.const 16
                    i32.add
                    local.get 12
                    i64.load
                    i64.store
                    local.get 0
                    local.get 0
                    i64.load offset=40
                    i64.store offset=232
                    local.get 0
                    local.get 0
                    i32.load16_u offset=36
                    i32.store16 offset=100
                    local.get 0
                    local.get 0
                    i64.load offset=8
                    i64.store offset=72
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            i32.const 65536
                            call $ext_get_storage
                            br_if 0 (;@12;)
                            call $ext_scratch_size
                            local.set 4
                            i32.const 0
                            local.set 7
                            local.get 0
                            i32.const 0
                            i32.store offset=304
                            local.get 0
                            i64.const 1
                            i64.store offset=296
                            local.get 4
                            br_if 1 (;@11;)
                            i32.const 1
                            local.set 1
                            local.get 0
                            i32.const 296
                            i32.add
                            local.set 4
                            br 2 (;@10;)
                          end
                          i32.const 65748
                          call $_ZN4core9panicking5panic17h76795e44271f3481E
                          unreachable
                        end
                        local.get 0
                        i32.const 296
                        i32.add
                        local.get 4
                        call $_ZN5alloc3vec12Vec$LT$T$GT$6resize17hb64dac7d6b3d3a8bE
                        local.get 0
                        i32.load offset=296
                        local.tee 1
                        i32.const 0
                        local.get 4
                        call $ext_scratch_read
                        local.get 0
                        i32.load offset=304
                        local.tee 7
                        i32.const 31
                        i32.gt_u
                        br_if 1 (;@9;)
                        local.get 0
                        i32.const 296
                        i32.add
                        local.set 4
                      end
                      local.get 0
                      i32.const 296
                      i32.add
                      local.get 7
                      i32.add
                      i32.const 0
                      i32.const 32
                      local.get 7
                      i32.sub
                      call $memset
                      drop
                      local.get 4
                      local.get 1
                      local.get 7
                      call $memcpy
                      drop
                      i32.const 65748
                      call $_ZN4core9panicking5panic17h76795e44271f3481E
                      unreachable
                    end
                    local.get 0
                    i32.load offset=300
                    local.set 4
                    local.get 1
                    i32.const 24
                    i32.add
                    i64.load align=1
                    local.set 11
                    local.get 1
                    i32.const 16
                    i32.add
                    i64.load align=1
                    local.set 16
                    local.get 1
                    i64.load align=1
                    local.set 17
                    local.get 0
                    i32.const 104
                    i32.add
                    i32.const 8
                    i32.add
                    local.get 1
                    i32.const 8
                    i32.add
                    i64.load align=1
                    i64.store
                    local.get 0
                    i32.const 104
                    i32.add
                    i32.const 16
                    i32.add
                    local.get 16
                    i64.store
                    local.get 0
                    i32.const 104
                    i32.add
                    i32.const 24
                    i32.add
                    local.get 11
                    i64.store
                    local.get 0
                    local.get 17
                    i64.store offset=104
                    block  ;; label = @9
                      local.get 4
                      i32.eqz
                      br_if 0 (;@9;)
                      local.get 1
                      local.get 4
                      call $__rust_dealloc
                    end
                    local.get 0
                    i32.const 136
                    i32.add
                    call $_ZN16restore_contract3ext6caller17hea16993b5102bcbbE
                    local.get 0
                    i32.const 104
                    i32.add
                    local.get 0
                    i32.const 136
                    i32.add
                    i32.const 32
                    call $memcmp
                    br_if 5 (;@3;)
                    block  ;; label = @9
                      block  ;; label = @10
                        local.get 6
                        br_if 0 (;@10;)
                        local.get 0
                        i32.const 168
                        i32.add
                        i32.const 24
                        i32.add
                        local.get 0
                        i32.const 232
                        i32.add
                        i32.const 24
                        i32.add
                        i64.load
                        i64.store
                        local.get 0
                        i32.const 168
                        i32.add
                        i32.const 16
                        i32.add
                        local.get 0
                        i32.const 232
                        i32.add
                        i32.const 16
                        i32.add
                        i64.load
                        i64.store
                        local.get 0
                        i32.const 168
                        i32.add
                        i32.const 8
                        i32.add
                        local.get 0
                        i32.const 232
                        i32.add
                        i32.const 8
                        i32.add
                        i64.load
                        i64.store
                        local.get 0
                        local.get 0
                        i64.load offset=232
                        i64.store offset=168
                        local.get 0
                        i32.const 168
                        i32.add
                        local.get 5
                        i32.const 0
                        local.get 5
                        select
                        local.tee 1
                        i32.const 0
                        i32.ne
                        local.get 1
                        local.get 10
                        i64.const 32
                        i64.shr_u
                        i32.wrap_i64
                        i32.const 0
                        local.get 1
                        select
                        call $ext_set_storage
                        local.get 5
                        i32.eqz
                        br_if 1 (;@9;)
                        local.get 10
                        i32.wrap_i64
                        local.tee 1
                        i32.eqz
                        br_if 1 (;@9;)
                        local.get 5
                        local.get 1
                        call $__rust_dealloc
                        br 1 (;@9;)
                      end
                      local.get 0
                      i32.const 200
                      i32.add
                      i32.const 24
                      i32.add
                      local.get 0
                      i32.const 232
                      i32.add
                      i32.const 24
                      i32.add
                      i64.load
                      i64.store
                      local.get 0
                      i32.const 200
                      i32.add
                      i32.const 16
                      i32.add
                      local.get 0
                      i32.const 232
                      i32.add
                      i32.const 16
                      i32.add
                      i64.load
                      i64.store
                      local.get 0
                      i32.const 200
                      i32.add
                      i32.const 8
                      i32.add
                      local.get 0
                      i32.const 232
                      i32.add
                      i32.const 8
                      i32.add
                      i64.load
                      i64.store
                      local.get 0
                      local.get 0
                      i64.load offset=232
                      i64.store offset=200
                      local.get 0
                      i32.const 287
                      i32.add
                      local.get 0
                      i32.const 72
                      i32.add
                      i32.const 8
                      i32.add
                      i64.load
                      i64.store align=1
                      local.get 0
                      i32.const 295
                      i32.add
                      local.get 0
                      i32.const 72
                      i32.add
                      i32.const 16
                      i32.add
                      i32.load8_u
                      i32.store8
                      local.get 0
                      local.get 0
                      i32.const 102
                      i32.add
                      i32.load8_u
                      i32.store8 offset=266
                      local.get 0
                      local.get 0
                      i32.load16_u offset=100
                      i32.store16 offset=264
                      local.get 0
                      local.get 10
                      i64.store offset=271 align=1
                      local.get 0
                      local.get 5
                      i32.store offset=267 align=1
                      local.get 0
                      local.get 0
                      i64.load offset=72
                      i64.store offset=279 align=1
                      local.get 0
                      i32.const 296
                      i32.add
                      i32.const 24
                      i32.add
                      i64.const 4774451407313060418
                      i64.store
                      local.get 0
                      i32.const 296
                      i32.add
                      i32.const 16
                      i32.add
                      i64.const 4774451407313060418
                      i64.store
                      local.get 0
                      i32.const 296
                      i32.add
                      i32.const 8
                      i32.add
                      i64.const 4774451407313060418
                      i64.store
                      local.get 0
                      i64.const 4774451407313060418
                      i64.store offset=296
                      i32.const 16
                      call $__rust_alloc
                      local.tee 1
                      i32.eqz
                      br_if 7 (;@2;)
                      local.get 1
                      local.get 15
                      i64.store align=1
                      local.get 1
                      local.get 14
                      i64.store offset=8 align=1
                      local.get 0
                      i32.const 200
                      i32.add
                      i32.const 32
                      local.get 0
                      i32.const 264
                      i32.add
                      i32.const 32
                      local.get 1
                      i32.const 16
                      local.get 0
                      i32.const 296
                      i32.add
                      i32.const 1
                      call $ext_restore_to
                      local.get 1
                      i32.const 16
                      call $__rust_dealloc
                    end
                    i32.const 1
                    i32.const 0
                    call $ext_scratch_write
                    block  ;; label = @9
                      local.get 3
                      i32.eqz
                      br_if 0 (;@9;)
                      local.get 2
                      local.get 3
                      call $__rust_dealloc
                    end
                    local.get 0
                    i32.const 336
                    i32.add
                    global.set 0
                    i32.const 0
                    return
                  end
                  local.get 4
                  local.get 1
                  call $_ZN4core5slice22slice_index_order_fail17hcdfc65392f282fd5E
                  unreachable
                end
                local.get 4
                local.get 1
                call $_ZN4core5slice22slice_index_order_fail17hcdfc65392f282fd5E
                unreachable
              end
              local.get 4
              local.get 1
              call $_ZN4core5slice22slice_index_order_fail17hcdfc65392f282fd5E
              unreachable
            end
            local.get 5
            local.get 1
            call $_ZN4core5slice22slice_index_order_fail17hcdfc65392f282fd5E
            unreachable
          end
          local.get 4
          i32.const 1
          call $rust_oom
          unreachable
        end
        i32.const 65592
        call $_ZN4core9panicking5panic17h76795e44271f3481E
        unreachable
      end
      i32.const 16
      i32.const 1
      call $rust_oom
      unreachable
    end
    i32.const 65748
    call $_ZN4core9panicking5panic17h76795e44271f3481E
    unreachable)
  (func $_ZN5alloc3vec12Vec$LT$T$GT$6resize17hb64dac7d6b3d3a8bE (type 6) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.const 8
            i32.add
            local.tee 2
            i32.load
            local.tee 3
            local.get 1
            i32.ge_u
            br_if 0 (;@4;)
            block  ;; label = @5
              block  ;; label = @6
                local.get 0
                i32.const 4
                i32.add
                i32.load
                local.tee 4
                local.get 3
                i32.sub
                local.get 1
                local.get 3
                i32.sub
                local.tee 5
                i32.lt_u
                br_if 0 (;@6;)
                local.get 0
                i32.load
                local.set 4
                local.get 3
                local.set 0
                br 1 (;@5;)
              end
              block  ;; label = @6
                local.get 3
                local.get 5
                i32.add
                local.tee 6
                local.get 3
                i32.ge_u
                br_if 0 (;@6;)
                i32.const 0
                local.set 7
                br 5 (;@1;)
              end
              i32.const 0
              local.set 7
              local.get 4
              i32.const 1
              i32.shl
              local.tee 8
              local.get 6
              local.get 8
              local.get 6
              i32.gt_u
              select
              local.tee 6
              i32.const 0
              i32.lt_s
              br_if 4 (;@1;)
              block  ;; label = @6
                block  ;; label = @7
                  local.get 4
                  br_if 0 (;@7;)
                  local.get 6
                  call $__rust_alloc
                  local.set 4
                  br 1 (;@6;)
                end
                local.get 0
                i32.load
                local.get 4
                local.get 6
                call $__rust_realloc
                local.set 4
              end
              local.get 4
              i32.eqz
              br_if 2 (;@3;)
              local.get 0
              local.get 4
              i32.store
              local.get 0
              i32.const 4
              i32.add
              local.get 6
              i32.store
              local.get 0
              i32.const 8
              i32.add
              i32.load
              local.set 0
            end
            block  ;; label = @5
              local.get 5
              i32.const 2
              i32.lt_u
              br_if 0 (;@5;)
              local.get 3
              i32.const -1
              i32.xor
              local.get 1
              i32.add
              local.set 1
              loop  ;; label = @6
                local.get 4
                local.get 0
                i32.add
                i32.const 0
                i32.store8
                local.get 0
                i32.const 1
                i32.add
                local.set 0
                local.get 1
                i32.const -1
                i32.add
                local.tee 1
                br_if 0 (;@6;)
                br 4 (;@2;)
              end
            end
            local.get 5
            br_if 2 (;@2;)
            local.get 0
            local.set 1
          end
          local.get 2
          local.get 1
          i32.store
          return
        end
        local.get 6
        i32.const 1
        call $rust_oom
        unreachable
      end
      local.get 4
      local.get 0
      i32.add
      i32.const 0
      i32.store8
      local.get 2
      local.get 0
      i32.const 1
      i32.add
      i32.store
      return
    end
    block  ;; label = @1
      local.get 7
      br_if 0 (;@1;)
      call $_ZN5alloc7raw_vec17capacity_overflow17h159a6426f442e157E
      unreachable
    end
    i32.const 65660
    call $_ZN4core9panicking5panic17h76795e44271f3481E
    unreachable)
  (func $_ZN5alloc7raw_vec19RawVec$LT$T$C$A$GT$11allocate_in28_$u7b$$u7b$closure$u7d$$u7d$17hb4614da3fb236ccdE (type 7)
    call $_ZN5alloc7raw_vec17capacity_overflow17h159a6426f442e157E
    unreachable)
  (func $__rust_alloc_zeroed (type 0) (param i32) (result i32)
    local.get 0
    call $__rg_alloc_zeroed)
  (func $__rust_dealloc (type 6) (param i32 i32)
    local.get 0
    local.get 1
    call $__rg_dealloc)
  (func $_ZN4core9panicking5panic17h76795e44271f3481E (type 8) (param i32)
    call $_ZN4core9panicking9panic_fmt17h208bc982e6cfe835E
    unreachable)
  (func $_ZN16restore_contract3ext6caller17hea16993b5102bcbbE (type 8) (param i32)
    (local i32 i32 i32 i64 i64 i64)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 1
    global.set 0
    call $ext_caller
    block  ;; label = @1
      block  ;; label = @2
        call $ext_scratch_size
        local.tee 2
        br_if 0 (;@2;)
        i32.const 0
        local.set 2
        i32.const 1
        local.set 3
        br 1 (;@1;)
      end
      local.get 1
      i32.const 0
      i32.store offset=8
      local.get 1
      i64.const 1
      i64.store
      local.get 1
      local.get 2
      call $_ZN5alloc3vec12Vec$LT$T$GT$6resize17hb64dac7d6b3d3a8bE
      local.get 1
      i32.load
      local.tee 3
      i32.const 0
      local.get 2
      call $ext_scratch_read
      local.get 1
      i32.load offset=8
      local.tee 2
      i32.const 31
      i32.le_u
      br_if 0 (;@1;)
      local.get 1
      i32.load offset=4
      local.set 2
      local.get 3
      i32.const 24
      i32.add
      i64.load align=1
      local.set 4
      local.get 3
      i32.const 16
      i32.add
      i64.load align=1
      local.set 5
      local.get 3
      i32.const 8
      i32.add
      i64.load align=1
      local.set 6
      local.get 0
      local.get 3
      i64.load align=1
      i64.store align=1
      local.get 0
      i32.const 8
      i32.add
      local.get 6
      i64.store align=1
      local.get 0
      i32.const 16
      i32.add
      local.get 5
      i64.store align=1
      local.get 0
      i32.const 24
      i32.add
      local.get 4
      i64.store align=1
      block  ;; label = @2
        local.get 2
        i32.eqz
        br_if 0 (;@2;)
        local.get 3
        local.get 2
        call $__rust_dealloc
      end
      local.get 1
      i32.const 32
      i32.add
      global.set 0
      return
    end
    local.get 1
    local.get 2
    i32.add
    i32.const 0
    i32.const 32
    local.get 2
    i32.sub
    call $memset
    drop
    local.get 1
    local.get 3
    local.get 2
    call $memcpy
    drop
    i32.const 65748
    call $_ZN4core9panicking5panic17h76795e44271f3481E
    unreachable)
  (func $__rust_alloc (type 0) (param i32) (result i32)
    local.get 0
    call $__rg_alloc)
  (func $_ZN4core5slice22slice_index_order_fail17hcdfc65392f282fd5E (type 6) (param i32 i32)
    call $_ZN4core9panicking9panic_fmt17h208bc982e6cfe835E
    unreachable)
  (func $deploy (type 2) (result i32)
    (local i32 i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 0
    global.set 0
    local.get 0
    call $_ZN16restore_contract3ext6caller17hea16993b5102bcbbE
    block  ;; label = @1
      i32.const 32
      call $__rust_alloc
      local.tee 1
      br_if 0 (;@1;)
      i32.const 32
      i32.const 1
      call $rust_oom
      unreachable
    end
    local.get 1
    local.get 0
    i64.load align=1
    i64.store align=1
    local.get 1
    i32.const 24
    i32.add
    local.get 0
    i32.const 24
    i32.add
    i64.load align=1
    i64.store align=1
    local.get 1
    i32.const 16
    i32.add
    local.get 0
    i32.const 16
    i32.add
    i64.load align=1
    i64.store align=1
    local.get 1
    i32.const 8
    i32.add
    local.get 0
    i32.const 8
    i32.add
    i64.load align=1
    i64.store align=1
    i32.const 65536
    i32.const 1
    local.get 1
    i32.const 32
    call $ext_set_storage
    local.get 1
    i32.const 32
    call $__rust_dealloc
    i32.const 1
    i32.const 0
    call $ext_scratch_write
    local.get 0
    i32.const 32
    i32.add
    global.set 0
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
        i32.const 65908
        i32.store offset=4
        local.get 1
        local.get 0
        i32.const 2
        i32.shl
        i32.const 65912
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
          i32.const 65836
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
              i32.const 65884
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
            i32.const 65884
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
          i32.const 65836
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
      i32.load offset=65908
      i32.store offset=12
      block  ;; label = @2
        local.get 3
        i32.const 1
        local.get 1
        i32.const 12
        i32.add
        i32.const 65657
        i32.const 65860
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
        i32.const 65657
        i32.const 65860
        call $_ZN9wee_alloc15alloc_first_fit17h2958d0738bb374faE.llvm.1804655379480408609
        local.set 0
      end
      i32.const 0
      local.get 1
      i32.load offset=12
      i32.store offset=65908
    end
    local.get 1
    i32.const 16
    i32.add
    global.set 0
    local.get 0)
  (func $__rg_dealloc (type 6) (param i32 i32)
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
        i32.const 65908
        i32.store offset=8
        local.get 2
        local.get 0
        i32.const 2
        i32.shl
        i32.const 65912
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
        i32.const 65836
        call $_ZN9wee_alloc8WeeAlloc12dealloc_impl28_$u7b$$u7b$closure$u7d$$u7d$17hdfb5b4eccc8c4dccE
        local.get 0
        local.get 2
        i32.load offset=12
        i32.store
        br 1 (;@1;)
      end
      local.get 2
      i32.const 0
      i32.load offset=65908
      i32.store offset=12
      local.get 2
      i32.const 4
      i32.add
      local.get 2
      i32.const 12
      i32.add
      i32.const 65657
      i32.const 65860
      call $_ZN9wee_alloc8WeeAlloc12dealloc_impl28_$u7b$$u7b$closure$u7d$$u7d$17hdfb5b4eccc8c4dccE
      i32.const 0
      local.get 2
      i32.load offset=12
      i32.store offset=65908
    end
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func $_ZN9wee_alloc8WeeAlloc12dealloc_impl28_$u7b$$u7b$closure$u7d$$u7d$17hdfb5b4eccc8c4dccE (type 4) (param i32 i32 i32 i32)
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
  (func $__rg_realloc (type 9) (param i32 i32 i32) (result i32)
    (local i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 3
    global.set 0
    block  ;; label = @1
      local.get 2
      call $_ZN64_$LT$wee_alloc..WeeAlloc$u20$as$u20$core..alloc..GlobalAlloc$GT$5alloc17h1e6fa0f2752bb80fE
      local.tee 4
      i32.eqz
      br_if 0 (;@1;)
      local.get 4
      local.get 0
      local.get 2
      local.get 1
      local.get 1
      local.get 2
      i32.gt_u
      select
      call $memcpy
      drop
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 3
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
        local.tee 2
        i32.const 255
        i32.gt_u
        br_if 0 (;@2;)
        local.get 3
        i32.const 65908
        i32.store offset=8
        local.get 3
        local.get 2
        i32.const 2
        i32.shl
        i32.const 65912
        i32.add
        local.tee 2
        i32.load
        i32.store offset=12
        local.get 3
        i32.const 4
        i32.add
        local.get 3
        i32.const 12
        i32.add
        local.get 3
        i32.const 8
        i32.add
        i32.const 65836
        call $_ZN9wee_alloc8WeeAlloc12dealloc_impl28_$u7b$$u7b$closure$u7d$$u7d$17hdfb5b4eccc8c4dccE
        local.get 2
        local.get 3
        i32.load offset=12
        i32.store
        br 1 (;@1;)
      end
      local.get 3
      i32.const 0
      i32.load offset=65908
      i32.store offset=12
      local.get 3
      i32.const 4
      i32.add
      local.get 3
      i32.const 12
      i32.add
      i32.const 65657
      i32.const 65860
      call $_ZN9wee_alloc8WeeAlloc12dealloc_impl28_$u7b$$u7b$closure$u7d$$u7d$17hdfb5b4eccc8c4dccE
      i32.const 0
      local.get 3
      i32.load offset=12
      i32.store offset=65908
    end
    local.get 3
    i32.const 16
    i32.add
    global.set 0
    local.get 4)
  (func $__rg_alloc_zeroed (type 0) (param i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      call $_ZN64_$LT$wee_alloc..WeeAlloc$u20$as$u20$core..alloc..GlobalAlloc$GT$5alloc17h1e6fa0f2752bb80fE
      local.tee 1
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      i32.const 0
      local.get 0
      call $memset
      drop
    end
    local.get 1)
  (func $__rust_realloc (type 9) (param i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    call $__rg_realloc)
  (func $_ZN5alloc7raw_vec17capacity_overflow17h159a6426f442e157E (type 7)
    i32.const 65616
    call $_ZN4core9panicking5panic17h76795e44271f3481E
    unreachable)
  (func $_ZN4core9panicking9panic_fmt17h208bc982e6cfe835E (type 7)
    unreachable
    unreachable)
  (func $_ZN70_$LT$wee_alloc..LargeAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$22new_cell_for_free_list17h42f7fb54ef6be16cE (type 4) (param i32 i32 i32 i32)
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
  (func $_ZN9wee_alloc15alloc_first_fit17h2958d0738bb374faE.llvm.1804655379480408609 (type 10) (param i32 i32 i32 i32 i32) (result i32)
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
  (func $_ZN4core3ptr18real_drop_in_place17hd173886e09796329E (type 8) (param i32))
  (func $_ZN4core3ptr18real_drop_in_place17h062cda866a759cd0E (type 8) (param i32))
  (func $_ZN88_$LT$wee_alloc..size_classes..SizeClassAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$22new_cell_for_free_list17h9a4ed9b46a4acff7E (type 4) (param i32 i32 i32 i32)
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
          i32.const 65884
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
          i32.const 65884
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
  (func $memset (type 9) (param i32 i32 i32) (result i32)
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
        i32.store8
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        local.get 2
        i32.const -1
        i32.add
        local.tee 2
        br_if 0 (;@2;)
      end
    end
    local.get 0)
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
  (func $memcmp (type 9) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    i32.const 0
    local.set 3
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        loop  ;; label = @3
          local.get 0
          i32.load8_u
          local.tee 4
          local.get 1
          i32.load8_u
          local.tee 5
          i32.ne
          br_if 1 (;@2;)
          local.get 1
          i32.const 1
          i32.add
          local.set 1
          local.get 0
          i32.const 1
          i32.add
          local.set 0
          local.get 2
          i32.const -1
          i32.add
          local.tee 2
          i32.eqz
          br_if 2 (;@1;)
          br 0 (;@3;)
        end
      end
      local.get 4
      local.get 5
      i32.sub
      local.set 3
    end
    local.get 3)
  (table (;0;) 9 9 funcref)
  (global (;0;) (mut i32) (i32.const 65536))
  (global (;1;) i32 (i32.const 66936))
  (global (;2;) i32 (i32.const 66936))
  (export "__data_end" (global 1))
  (export "__heap_base" (global 2))
  (export "call" (func $call))
  (export "deploy" (func $deploy))
  (elem (;0;) (i32.const 1) $_ZN4core3ptr18real_drop_in_place17h062cda866a759cd0E $_ZN88_$LT$wee_alloc..size_classes..SizeClassAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$22new_cell_for_free_list17h9a4ed9b46a4acff7E $_ZN88_$LT$wee_alloc..size_classes..SizeClassAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$13min_cell_size17h19259326bbc840afE $_ZN88_$LT$wee_alloc..size_classes..SizeClassAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$32should_merge_adjacent_free_cells17hcd1726812e076be6E $_ZN4core3ptr18real_drop_in_place17hd173886e09796329E $_ZN70_$LT$wee_alloc..LargeAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$22new_cell_for_free_list17h42f7fb54ef6be16cE $_ZN70_$LT$wee_alloc..LargeAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$13min_cell_size17h0c0e4c4ac7e0c29cE $_ZN70_$LT$wee_alloc..LargeAllocPolicy$u20$as$u20$wee_alloc..AllocPolicy$GT$32should_merge_adjacent_free_cells17h9d94f9e9f41ec656E)
  (data (;0;) (i32.const 65536) "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBexplicit panicsrc/lib.rs \00\01\00\0e\00\00\00.\00\01\00\0a\00\00\00O\00\00\00\09\00\00\00h\00\01\00\11\00\00\00\bc\00\01\00\17\00\00\00\09\03\00\00\05\00\00\00capacity overflow\00\00\00\94\00\01\00(\00\00\00\bc\00\01\00\17\00\00\00\0a\02\00\00'\00\00\00internal error: entered unreachable codesrc/liballoc/raw_vec.rs\00\ec\00\01\00+\00\00\00\17\01\01\00\15\00\00\00z\01\00\00\15\00\00\00called `Option::unwrap()` on a `None` valuesrc/libcore/option.rs\01\00\00\00\04\00\00\00\04\00\00\00\02\00\00\00\03\00\00\00\04\00\00\00\05\00\00\00\00\00\00\00\01\00\00\00\06\00\00\00\07\00\00\00\08\00\00\00\05\00\00\00\00\00\00\00\01\00\00\00\06\00\00\00\07\00\00\00\08\00\00\00")
  (data (;1;) (i32.const 65908) "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"))
