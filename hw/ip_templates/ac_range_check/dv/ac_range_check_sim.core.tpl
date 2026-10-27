CAPI=3:
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: ${instance_vlnv(f"lowrisc:dv:{module_instance_name}_sim:0.1")}
description: "AC_RANGE_CHECK DV sim target"
filesets:
  files_rtl:
    depend:
      - lowrisc:ip:tlul
      - ${instance_vlnv(f"lowrisc:ip:{module_instance_name}:0.1")}
    file_type: systemVerilogSource

  files_dv:
    depend:
      - ${instance_vlnv(f"lowrisc:dv:{module_instance_name}_test")}
      - ${instance_vlnv(f"lowrisc:dv:{module_instance_name}_sva")}
    files:
      - env/${module_instance_name}_misc_io_if.sv
      - tb/tb.sv
    file_type: systemVerilogSource

targets:
  sim:
    toplevel: tb
    filesets:
      - files_rtl
      - files_dv
    flow_options:
      tool: vcs
    flow: sim
    flags: {tool: vcs}

  # CAPI=2 ran this target with dvsim's `--tool={tool}`
  # (hw/lint/tools/dvsim/common_lint_cfg.hjson), which overrode the `vcs` it inherits.
  # OpenTitan's CI lints with Verible. A CAPI=3 core does not take `--tool`, and
  # Edalize has no flow API for Verible yet, so this target runs the `sim` flow
  # with vcs, not a lint.
  lint:
    extends: sim
