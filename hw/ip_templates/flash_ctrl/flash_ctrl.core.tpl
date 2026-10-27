CAPI=3:
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: ${instance_vlnv("lowrisc:ip:flash_ctrl:0.1")}
description: "Flash Controller"

vars:
  tool_ascentlint:
    datatype: bool
    default: false
    description: Set when linting with AscentLint, to add AscentLint waivers. Edalize has no flow API for AscentLint yet, so no CAPI=3 target sets it
  tool_slang:
    datatype: bool
    default: false
    description: Set when linting with slang, to add slang waivers. Edalize has no flow API for slang yet, so no CAPI=3 target sets it
  tool_veriblelint:
    datatype: bool
    default: false
    description: Set when linting with Verible, to add Verible lint rules and waivers. Edalize has no flow API for Verible lint yet, so no CAPI=3 target sets it
  tool_verilator:
    datatype: bool
    default: false
    description: Set by top-level targets that build with Verilator, to add Verilator waivers and checks

filesets:
  files_rtl:
    depend:
      - lowrisc:ip:tlul
      - lowrisc:prim:all
      - lowrisc:prim:count
      - lowrisc:prim:edge_detector
      - lowrisc:prim:flash
      - lowrisc:prim:flop_2sync
      - lowrisc:prim:gf_mult
      - lowrisc:prim:lc_sync
      - lowrisc:prim:lfsr
      - lowrisc:prim:secded
      - lowrisc:prim:sparse_fsm
      - lowrisc:ip:otp_ctrl_pkg
      - ${instance_vlnv("lowrisc:ip:flash_ctrl_top_specific_pkg")}
      - ${instance_vlnv("lowrisc:ip:flash_ctrl_reg")}
      - ${instance_vlnv("lowrisc:constants:top_pkg")}
      - lowrisc:ip:jtag_pkg
    files:
      - rtl/flash_ctrl.sv
      - rtl/flash_ctrl_erase.sv
      - rtl/flash_ctrl_prog.sv
      - rtl/flash_ctrl_rd.sv
      - rtl/flash_ctrl_arb.sv
      - rtl/flash_ctrl_info_cfg.sv
      - rtl/flash_ctrl_lcmgr.sv
      - rtl/flash_ctrl_region_cfg.sv
      - rtl/flash_mp.sv
      - rtl/flash_mp_data_region_sel.sv
      - rtl/flash_phy.sv
      - rtl/flash_phy_core.sv
      - rtl/flash_phy_rd.sv
      - rtl/flash_phy_rd_buffers.sv
      - rtl/flash_phy_rd_buf_dep.sv
      - rtl/flash_phy_prog.sv
      - rtl/flash_phy_erase.sv
      - rtl/flash_phy_scramble.sv
    file_type: systemVerilogSource

  files_verilator_waiver:
    depend:
      # common waivers
      - lowrisc:lint:common
      - lowrisc:lint:comportable
    files:
      - lint/flash_ctrl.vlt
    file_type: vlt

  files_ascentlint_waiver:
    depend:
      # common waivers
      - lowrisc:lint:common
      - lowrisc:lint:comportable
    files:
      - lint/flash_ctrl.waiver
    file_type: waiver

  files_veriblelint_waiver:
    depend:
      # common waivers
      - lowrisc:lint:common
      - lowrisc:lint:comportable

  files_slang_waiver:
    depend:
      # common waivers
      - lowrisc:lint:common
      - lowrisc:lint:comportable

parameters:
  SYNTHESIS:
    datatype: bool
    paramtype: vlogdefine


targets:
  default:
    filesets:
      - if: "vars.tool_verilator"
        add: [files_verilator_waiver]
      - if: "vars.tool_ascentlint"
        add: [files_ascentlint_waiver]
      - if: "vars.tool_veriblelint"
        add: [files_veriblelint_waiver]
      - if: "vars.tool_slang"
        add: [files_slang_waiver]
      - files_rtl
    toplevel: flash_ctrl

  lint:
    extends: default
    vars: {tool_verilator: true}
    flow: lint
    flags: {tool: verilator}
    parameters:
      - SYNTHESIS=true
    flow_options:
      tool: verilator
      mode: lint-only
      verilator_options:
        - "-Wall"
