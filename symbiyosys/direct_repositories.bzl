load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def rules_symbiyosys_direct_deps():
    http_archive(
        name = "rules_verilog",
        strip_prefix = "rules_verilog-0.1.0",
        sha256 = "401b3f591f296f6fd2f6656f01afc1f93111e10b81b9a9d291f9c04b3e4a3e8b",
        url = "https://github.com/agoessling/rules_verilog/archive/v0.1.0.zip",
    )

    http_archive(
        name = "rules_foreign_cc",
        strip_prefix = "rules_foreign_cc-ed95b95affecaa3ea3bf7bab3e0ab6aa847dfb06",
        sha256 = "21177439c27c994fd9b6e04d4ed6cec79d7dbcf174649f8d70e396dd582d1c82",
        url = "https://github.com/bazelbuild/rules_foreign_cc/archive/ed95b95affecaa3ea3bf7bab3e0ab6aa847dfb06.zip",
    )

    all_content = """
filegroup(
    name = "all",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)"""

    http_archive(
        name = "yosys_archive",
        build_file_content = all_content,
        strip_prefix = "yosys-06347b119b08257eff37cdd10ed802e794c1a3cf",
        sha256 = "33108d1ccf9ad4277071ad151994e428e8f39cafde30a0db9c910ac08056b7c3",
        url = "https://github.com/YosysHQ/yosys/archive/06347b119b08257eff37cdd10ed802e794c1a3cf.zip",
    )

    http_archive(
        name = "symbiyosys_archive",
        build_file = "@rules_symbiyosys//symbiyosys/tools:symbiyosys.BUILD",
        strip_prefix = "SymbiYosys-37a1fec1206c70c33565c0a1f3e6605d03ce47ac",
        sha256 = "1719bdbf5d29a9d3038e2c57ddd9b2fcfcbc36bf8db4e875e7fce98d65daae60",
        url = "https://github.com/YosysHQ/symbiyosys/archive/37a1fec1206c70c33565c0a1f3e6605d03ce47ac.zip",
    )

    http_archive(
        name = "yices_archive",
        build_file_content = all_content,
        strip_prefix = "yices2-426cdc6037ee0e34309edbe4e10bcda9a7211a41",
        sha256 = "8d29b11f2b05af1cb64ea5c5c01e46061e750b5724ff9595d477625a6f70edc6",
        url = "https://github.com/SRI-CSL/yices2/archive/426cdc6037ee0e34309edbe4e10bcda9a7211a41.zip",
    )
