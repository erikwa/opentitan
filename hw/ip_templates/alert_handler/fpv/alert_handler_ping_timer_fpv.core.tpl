CAPI=3:
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: ${instance_vlnv(f"lowrisc:fpv:{module_instance_name}_ping_timer_fpv:0.1")}
description: "${module_instance_name.upper()} FPV target"
filesets:
  files_formal:
    depend:
      - lowrisc:prim:all
      - ${instance_vlnv(f"lowrisc:ip:{module_instance_name}")}
    files:
      - vip/${module_instance_name}_ping_timer_assert_fpv.sv
      - tb/${module_instance_name}_ping_timer_bind_fpv.sv
      - tb/${module_instance_name}_ping_timer_tb.sv
    file_type: systemVerilogSource

targets:
  default:
    # note, this setting is just used
    # to generate a file list for jg
    flow_options:
      tool: icarus
    # FUSESOC-MIGRATE: `icarus` is a flow-API tool of Edalize with no flow of its name, so it runs under `sim`, and the core file does not say whether this target simulates or lints. Keep `flow: sim` to simulate, or write `flow: lint` (specification §7.5)
    flow: sim
    flags: {tool: icarus}
    filesets:
      - files_formal
    toplevel: ${module_instance_name}_ping_timer_tb

  formal:
    extends: default

  # CAPI=2 ran this target with dvsim's `--tool={tool}`
  # (hw/lint/tools/dvsim/common_lint_cfg.hjson), which overrode the `icarus` it inherits.
  # OpenTitan's CI lints with Verible. A CAPI=3 core does not take `--tool`, and
  # Edalize has no flow API for Verible yet, so this target runs the `sim` flow
  # with icarus, not a lint.
  lint:
    extends: default
