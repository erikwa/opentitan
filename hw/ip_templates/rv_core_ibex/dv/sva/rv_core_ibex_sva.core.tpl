CAPI=3:
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: ${instance_vlnv(f"lowrisc:dv:{module_instance_name}_sva:0.1")}
description: "${module_instance_name.upper()} assertion modules and bind file."
filesets:
  files_dv:
    depend:
      - lowrisc:fpv:csr_assert_gen
      - ${instance_vlnv(f"lowrisc:ip:{module_instance_name}:0.1")}
      - lowrisc:tlul:headers
      - lowrisc:prim:assert
    files:
      - ${module_instance_name}_bind.sv
    file_type: systemVerilogSource

  files_formal:
    depend:
      - ${instance_vlnv(f"lowrisc:ip:{module_instance_name}:0.1")}

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
