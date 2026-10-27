CAPI=3:
# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

name: "${package}"
description: "${description}"
% if files_veriblelint_waiver is not UNDEFINED:
vars:
  tool_veriblelint:
    datatype: bool
    default: false
    description: Set when linting with Verible, to add Verible lint rules and waivers. Edalize has no flow API for Verible lint yet, so no CAPI=3 target sets it

% endif
% if virtual_package is not UNDEFINED:
virtual:
  - ${virtual_package}
% endif

filesets:
  files_rtl:
  % if dependencies is not UNDEFINED:
    depend:
    % for dep in dependencies:
      - ${dep}
    % endfor
  % endif
    files:
    % for file in files:
      - ${file}
    % endfor
    file_type: systemVerilogSource

  % if files_veriblelint_waiver is not UNDEFINED:
  files_veriblelint_waiver:
    depend:
      - lowrisc:lint:common
      - lowrisc:lint:comportable
    files:
      - ${files_veriblelint_waiver}
    file_type: veriblelintWaiver

  % endif
targets:
  default:
    filesets:
      - files_rtl
    % if files_veriblelint_waiver is not UNDEFINED:
      - if: "vars.tool_veriblelint"
        add: [files_veriblelint_waiver]
    % endif
