CAPI=3:
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Register assertions and bind file. This needs to be templated because it
# needs the register layout (from racl_ctrl.hjson) to know what registers exist.

name: ${instance_vlnv(f"lowrisc:dv:{module_instance_name}_sva:0.1")}
description: "RACL_CTRL assertion modules and bind file."
filesets:
  files_dv:
    depend:
      - lowrisc:tlul:headers
      - lowrisc:fpv:csr_assert_gen
    files:
      - racl_ctrl_bind.sv
    file_type: systemVerilogSource

  files_formal:
    depend:
      - ${instance_vlnv(f"lowrisc:ip:{module_instance_name}")}

generate:
  csr_assert_gen:
    generator: csr_assert_gen
    parameters:
      spec: ../../data/${module_instance_name}.hjson

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
    toplevel: ${module_instance_name}
    # CAPI=2 got the tool from dvsim's `--tool=icarus`
    # (hw/formal/tools/dvsim/common_formal_cfg.hjson), which a CAPI=3 core does
    # not take. Icarus only sets up the file list for the formal tool.
    flow_options:
      tool: icarus
    flow: sim
    flags: {tool: icarus}
