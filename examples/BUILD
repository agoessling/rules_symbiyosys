load(
    "@rules_symbiyosys//symbiyosys:defs.bzl",
    "symbiyosys_test",
    "symbiyosys_trace",
)
load("@rules_verilog//verilog:defs.bzl", "verilog_module")

verilog_module(
    name = "counter_top",
    top = "counter_top",
    srcs = [
        "counter_top.sv",
    ],
    deps = [":counter"],
)

verilog_module(
    name = "counter",
    top = "counter",
    srcs = ["counter.sv"],
)

symbiyosys_test(
    name = "counter_pass",
    module = ":counter_top",
    params = {
        "MAX_VAL": "3",
    },
    modes = [
        "bmc",
        "prove",
    ],
    depth = 20,
    engine = "smtbmc",
)

symbiyosys_test(
    name = "counter_fail",
    module = ":counter_top",
    params = {
        "MAX_VAL": "15",
    },
    modes = [
        "bmc",
        "prove",
    ],
    depth = 20,
    engine = "smtbmc",
)

symbiyosys_trace(
    name = "counter_pass_trace",
    test = ":counter_pass",
    testonly = True,
)

symbiyosys_trace(
    name = "counter_fail_trace",
    test = ":counter_fail",
    testonly = True,
)
