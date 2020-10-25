load("@rules_foreign_cc//tools/build_defs:make.bzl", "make")
load("@rules_foreign_cc//tools/build_defs:configure.bzl", "configure_make")

make(
    name = "yosys",
    lib_source = "@yosys_archive//:all",
    binaries = [
        "yosys",
        "yosys-abc",
        "yosys-filterlib",
        "yosys-smtbmc",
    ],
    out_include_dir = "share",
    make_commands = [
        "make -j8",
        "make install PREFIX=$$INSTALLDIR$$",
    ],
    tags = [
        "requires-network",
    ],
    visibility = ["//visibility:public"],
)

configure_make(
    name = "yices",
    lib_source = "@yices_archive//:all",
    binaries = [
        "yices",
        "yices-sat",
        "yices-smt",
        "yices-smt2",
    ],
    make_commands = [
        "make -j8",
        "make install PREFIX=$$INSTALLDIR$$",
    ],
    configure_in_place = True,
    autoreconf = True,
    visibility = ["//visibility:public"],
)

py_binary(
    name = "symbiyosys_wrapper",
    srcs = ["symbiyosys_wrapper.py"],
    visibility = ["//visibility:public"],
)
