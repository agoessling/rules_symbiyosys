# rules_symbiyosys

Provides [Bazel](https://bazel.build/) rules for
[Symbiyosys](https://symbiyosys.readthedocs.io/en/latest/).

Currently the only supported engine is `smtbmc` with the `yices` solver.

`symbiyosys_test` is provided as a Bazel test rule.  `symbiyosys_trace` utilizes `gtkwave_wrapper`
from [rules_verilog](https://github.com/agoessling/rules_verilog) to view traces produced by
Symbiyosys.

## Usage

See [examples/BUILD](examples/BUILD) for example usage.

### WORKSPACE

To incorporate `rules_symbiyosys` into your project copy the following into your `WORKSPACE` file.

```Starlark
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_symbiyosys",
    # See release page for latest version url and sha.
)

load("@rules_symbiyosys//symbiyosys:direct_repositories.bzl", "rules_symbiyosys_direct_deps")
rules_symbiyosys_direct_deps()

load("@rules_symbiyosys//symbiyosys:indirect_repositories.bzl", "rules_symbiyosys_indirect_deps")
rules_symbiyosys_indirect_deps()
```
