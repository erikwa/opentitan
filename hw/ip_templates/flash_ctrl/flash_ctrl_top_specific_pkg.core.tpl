CAPI=3:
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: ${instance_vlnv("lowrisc:ip:flash_ctrl_top_specific_pkg:0.1")}
description: "Top specific flash ctrl package"
vars:
  tool_ascentlint:
    datatype: bool
    default: false
    description: Set when linting with AscentLint, to add AscentLint waivers. Edalize has no flow API for AscentLint yet, so no CAPI=3 target sets it
  tool_veriblelint:
    datatype: bool
    default: false
    description: Set when linting with Verible, to add Verible lint rules and waivers. Edalize has no flow API for Verible lint yet, so no CAPI=3 target sets it
  tool_verilator:
    datatype: bool
    default: false
    description: Set by top-level targets that build with Verilator, to add Verilator waivers and checks

virtual:
  - lowrisc:virtual_ip:flash_ctrl_top_specific_pkg

filesets:
  files_rtl:
    depend:
      - ${instance_vlnv("lowrisc:constants:top_pkg")}
      - lowrisc:prim:util
      - lowrisc:ip:lc_ctrl_pkg
      - ${instance_vlnv("lowrisc:ip:pwrmgr_pkg")}
      - lowrisc:ip:jtag_pkg
      - lowrisc:ip:edn_pkg
      - lowrisc:tlul:headers
      - lowrisc:ip:flash_ctrl_pkg
      - lowrisc:systems:ast_pkg
    files:
      - rtl/flash_ctrl_reg_pkg.sv
      - rtl/flash_ctrl_top_specific_pkg.sv
      - rtl/flash_phy_pkg.sv
    file_type: systemVerilogSource

  files_verilator_waiver:
    depend:
      # common waivers
      - lowrisc:lint:common
      - lowrisc:lint:comportable
    files:
      - lint/flash_ctrl_top_specific_pkg.vlt
    file_type: vlt

  files_ascentlint_waiver:
    depend:
      # common waivers
      - lowrisc:lint:common
      - lowrisc:lint:comportable
    files:
      - lint/flash_ctrl_top_specific_pkg.waiver
    file_type: waiver

  files_veriblelint_waiver:
    depend:
      # common waivers
      - lowrisc:lint:common
      - lowrisc:lint:comportable


targets:
  default:
    filesets:
      - if: "vars.tool_verilator"
        add: [files_verilator_waiver]
      - if: "vars.tool_ascentlint"
        add: [files_ascentlint_waiver]
      - if: "vars.tool_veriblelint"
        add: [files_veriblelint_waiver]
      - files_rtl
