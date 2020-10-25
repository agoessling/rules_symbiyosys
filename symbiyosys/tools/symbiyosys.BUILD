py_binary(
    name = "sby",
    srcs = ["sbysrc/sby.py"],
    deps = [":sby_deps"],
    visibility = ["//visibility:public"],
)

py_library(
    name = "sby_deps",
    srcs = glob(["sbysrc/sby_*.py"]),
)
