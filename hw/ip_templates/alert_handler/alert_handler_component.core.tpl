CAPI=3:
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: ${instance_vlnv(f"lowrisc:ip:{module_instance_name}_component:0.1")}
description: "Alert Handler component without the CSRs"

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

filesets:
  files_rtl:
    depend:
      - lowrisc:ip:tlul
      - lowrisc:prim:all
      - lowrisc:prim:esc
      - lowrisc:prim:double_lfsr
      - lowrisc:prim:count
      - lowrisc:prim:edn_req
      - lowrisc:prim:buf
      - lowrisc:prim:mubi
      - lowrisc:prim:sparse_fsm
      - ${instance_vlnv(f"lowrisc:ip:{module_instance_name}_reg")}
    files:
      - rtl/${module_instance_name}_reg_wrap.sv
      - rtl/${module_instance_name}_lpg_ctrl.sv
      - rtl/${module_instance_name}_class.sv
      - rtl/${module_instance_name}_ping_timer.sv
      - rtl/${module_instance_name}_esc_timer.sv
      - rtl/${module_instance_name}_accu.sv
      - rtl/${module_instance_name}.sv
    file_type: systemVerilogSource

  files_verilator_waiver:
    depend:
      # common waivers
      - lowrisc:lint:common
      - lowrisc:lint:comportable
    files:
      - lint/${module_instance_name}.vlt
    file_type: vlt

  files_ascentlint_waiver:
    depend:
      # common waivers
      - lowrisc:lint:common
      - lowrisc:lint:comportable
    files:
      - lint/alert_handler.waiver
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
