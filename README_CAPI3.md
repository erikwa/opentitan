# OpenTitan on CAPI=3

This branch (`capi3-migrate`) converts OpenTitan's core files to CAPI=3 to test
`fusesoc core migrate` and CAPI=3 on a real code base. It needs the CAPI=3 branch of
FuseSoC.

## Status

| | Count |
|---|---|
| Core files | 827 |
| Converted to CAPI=3 | 825 |
| Left on CAPI=2 | 2 |
| Cores that load (`fusesoc core list`) | 827 |

`fusesoc run --setup` of every target with a flow (555), compared with the EDAM
CAPI=2 produces for the same target:

| Result | Targets |
|---|---|
| Same EDAM as CAPI=2 | 519 |
| Intended difference | 1 |
| Fails under both CAPI=2 and CAPI=3 | 35 |
| Works under CAPI=2, broken under CAPI=3 | 0 |

- **Intended difference:** `tb_cs_registers` `sim`. The flow API has no `libs`, so
  `reg_dpi.so` is in `verilator_options`.
- **Failures under both:** problems already in OpenTitan: targets without a
  `toplevel`, a missing `fi/strobe.sv`, dependency conflicts that need top-specific
  `--mapping` arguments, and `lint` targets that ask for an undeclared `SYNTHESIS`.
- **Not tested:** only setup was run; nothing was compiled or simulated.

## Left on CAPI=2

- `hw/ip/tlul/adapter_dmi.core`, `hw/ip/tlul/jtag_dtm.core`: they have `files: []`,
  which FuseSoC rejects. They sit under `lowrisc:ip:tlul`, so nearly every build fails
  to resolve until you delete that line (in a scratch copy).

## Not converted

CAPI=3 has only the flow API, and Edalize 0.6.8 has no flow-API implementation of
some tools. What used them stays in the core as a `# Not converted:` comment, to
restore once Edalize has one:

- the `format` targets of `hw/vendor/lowrisc_ibex/{ibex_core,ibex_top,ibex_top_tracing}.core`
  (Verible format);
- the AscentLint and slang options of `hw/lint/common.core`;
- the `lint` targets of `chip_sim.core` and `otp_ctrl_sim.core` in Earl Grey and
  Darjeeling, which inherit no flow (Verible lint).

## What to expect

- **dvsim does not work yet.** It passes `--tool=...`, which a CAPI=3 top level
  rejects. Run `fusesoc` directly.
- **`formal` targets** that named no tool now set `flow: sim` with `tool: icarus`, the
  setup dvsim used to produce a file list for the formal tool (73 cores, commented).
- **DV and FPV `lint` targets** (119) inherit `flow: sim` with VCS or Icarus from `sim`
  or `default`. CAPI=2 had dvsim override that with `--tool=veriblelint`; under CAPI=3
  they run a simulation setup, not lint. All are commented. Four more inherit no flow
  and are commented out (see above).
- **Flattened tool options:** 15 targets had `tools.<tool>` options moved into flat
  `flow_options`. Options for a tool the target does not run (`vcs_options` and
  `slang_options` in Verilator targets) are unused; the cores say so.
- **Tool flags are variables now.** Dependencies add Verilator waivers on
  `vars.tool_verilator`, which Verilator top levels set. Flags such as
  `fileset_tapeout` are `--var +fileset_tapeout` on the command line. Ibex's
  `FPGA_XILINX`, which CAPI=2 set on `tool_vivado`, is set on `flow == 'vivado'`.

## Running it

From the OpenTitan root, in a scratch copy without the two `files: []` lines:

```sh
OT=$PWD; mkdir ../ot-capi3 && cd ../ot-capi3
cp -a $OT/hw . && ln -s $OT/util util
sed -i '/^\s*files: \[\]\s*$/d' hw/ip/tlul/adapter_dmi.core hw/ip/tlul/jtag_dtm.core
python3 -m venv --system-site-packages venv   # keeps an editable FuseSoC in use
venv/bin/pip install hjson mako semantic-version systemrdl-compiler \
    peakrdl-systemrdl tabulate pyfinite mistletoe bitarray anytree crcmod pycryptodome
PATH=$PWD/venv/bin:$PATH fusesoc --cores-root hw run --setup --target=sim \
    --mapping=lowrisc:prim_generic:all:0.1 lowrisc:dv:uart_sim
```

The generators (ralgen, csr_assert_gen, …) need `util/` next to `hw/` and the Python
packages above; take the versions from `python-requirements.txt`.
