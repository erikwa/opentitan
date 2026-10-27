CAPI=3:
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: ${instance_vlnv(f"lowrisc:dv:{module_instance_name}_sim:0.1")}
description: "A racl_ctrl simulation"
filesets:
  files_rtl:
    depend:
      - ${instance_vlnv("lowrisc:constants:top_racl_pkg")}
      - ${instance_vlnv(f"lowrisc:ip:{module_instance_name}")}

  files_dv:
    depend:
      - lowrisc:dv:racl_ctrl_test
      - lowrisc:dv:racl_error_log_agent
      - ${instance_vlnv(f"lowrisc:dv:{module_instance_name}_sva")}
    files:
      - ${module_instance_name}_env_pkg.sv
      - ${module_instance_name}_env_cfg.sv: {is_include_file: true}
      - tb.sv
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
