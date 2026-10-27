CAPI=3:
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: ${instance_vlnv("lowrisc:dv:otp_ctrl_sim:0.1")}
description: "OTP_CTRL DV sim target"

filesets:
  files_rtl:
    depend:
      - ${instance_vlnv("lowrisc:ip:otp_ctrl_macro_pkg")}
      - ${instance_vlnv("lowrisc:ip:otp_ctrl")}
      - lowrisc:ip:otp_macro

  files_dv:
    depend:
      - lowrisc:dv:mem_bkdr_util
      - ${instance_vlnv("lowrisc:dv:otp_ctrl_test")}
      - ${instance_vlnv("lowrisc:dv:otp_ctrl_sva")}
      - ${instance_vlnv("lowrisc:dv:otp_ctrl_cov")}
    files:
      - tb.sv
    file_type: systemVerilogSource

targets:
  default:
    toplevel: tb
    filesets:
      - files_rtl
      - files_dv

  sim:
    extends: default
    flow_options:
      tool: vcs
    flow: sim
    flags: {tool: vcs}

  # Not converted: CAPI=3 has only the flow API, and Edalize 0.6.8
  # has no flow-API implementation of `veriblelint`. CAPI=2 ran this target
  # with dvsim's `--tool={tool}` (hw/lint/tools/dvsim/common_lint_cfg.hjson),
  # and OpenTitan's CI lints with Verible.
  # lint:
  #   extends: default
