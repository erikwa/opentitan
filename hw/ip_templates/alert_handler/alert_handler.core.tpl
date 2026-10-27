CAPI=3:
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
name: ${instance_vlnv(f"lowrisc:ip:{module_instance_name}:0.1")}
description: "Alert Handler"

filesets:
  files_rtl:
    depend:
      - ${instance_vlnv(f"lowrisc:ip:{module_instance_name}_component:0.1")}
      - ${instance_vlnv(f"lowrisc:ip:{module_instance_name}_reg:0.1")}
    file_type: systemVerilogSource

parameters:
  SYNTHESIS:
    datatype: bool
    paramtype: vlogdefine


targets:
  default:
    filesets:
      - files_rtl
    toplevel: ${module_instance_name}

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
