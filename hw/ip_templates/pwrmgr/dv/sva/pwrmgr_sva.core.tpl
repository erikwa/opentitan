CAPI=3:
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: ${instance_vlnv("lowrisc:dv:pwrmgr_sva:0.1")}
description: "PWRMGR assertion modules and bind file."
filesets:
  files_dv:
    depend:
      - lowrisc:tlul:headers
      - lowrisc:fpv:csr_assert_gen
      - lowrisc:dv:clkmgr_pwrmgr_sva_if
      - lowrisc:dv:pwrmgr_rstmgr_sva_if:0.1
      - ${instance_vlnv("lowrisc:ip:pwrmgr_pkg")}
    files:
      - pwrmgr_bind.sv
      - pwrmgr_clock_enables_sva_if.sv
      - pwrmgr_rstreqs_sva_if.sv
      - pwrmgr_sec_cm_checker_assert.sv
    file_type: systemVerilogSource

  files_formal:
    depend:
      - ${instance_vlnv("lowrisc:ip:pwrmgr:0.1")}

generate:
  csr_assert_gen:
    generator: csr_assert_gen
    parameters:
      spec: ../../data/pwrmgr.hjson

targets:
  default:
    filesets:
      - files_dv
    generate:
      - csr_assert_gen
  formal:
    extends: default
    filesets:
      - files_formal
      - files_dv
    toplevel: pwrmgr
    # CAPI=2 got the tool from dvsim's `--tool=icarus`
    # (hw/formal/tools/dvsim/common_formal_cfg.hjson), which a CAPI=3 core does
    # not take. Icarus only sets up the file list for the formal tool.
    flow_options:
      tool: icarus
    flow: sim
    flags: {tool: icarus}
