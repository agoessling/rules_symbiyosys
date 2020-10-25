load("@rules_verilog//verilog:defs.bzl", "VerilogModuleInfo")

def _short_dir(f):
  """Return the directory of the short_path."""
  return f.short_path[:-len(f.basename)]


def _get_binary(target, name):
    """Return the file associated with name in target."""
    # rules_foreign_cc creates one binary per output group.
    return getattr(target[OutputGroupInfo], name).to_list()[0]


def _symbiyosys_test_impl(ctx):
    top = ctx.attr.module[VerilogModuleInfo].top
    files = ctx.attr.module[VerilogModuleInfo].files.to_list()

    # Need to explicitly add runfiles prefix so paths are correct both when run directly and when
    # run from another rule.
    prefix = "${{RUNFILES_DIR}}/{}/".format(ctx.workspace_name)

    shell_cmd = [
        prefix + ctx.executable._symbiyosys_wrapper.short_path,
        "--sby_path",
        prefix + ctx.executable._symbiyosys_toolchain.short_path,
        "--yosys_path",
        prefix + _get_binary(ctx.attr._yosys_toolchain, "yosys").short_path,
        "--abc_path",
        prefix + _get_binary(ctx.attr._yosys_toolchain, "yosys-abc").short_path,
        "--smtbmc_path",
        prefix + _get_binary(ctx.attr._yosys_toolchain, "yosys-smtbmc").short_path,
        "--solver_paths",
        prefix + _short_dir(_get_binary(ctx.attr._yices_toolchain, "yices")),
        "--modes",
        " ".join(ctx.attr.modes),
        "--engine",
        ctx.attr.engine,
        "--top",
        top,
        "--params",
        " ".join([k + "=" + v for k, v in ctx.attr.params.items()]),
        "--depth",
        str(ctx.attr.depth),
        " ".join([prefix + f.short_path for f in files]),
        "$@",
    ]

    script = ctx.actions.declare_file("{}.sh".format(ctx.label.name))
    ctx.actions.write(script, " ".join(shell_cmd), is_executable = True)

    runfiles = ctx.runfiles(
        files = files,
        transitive_files = depset(transitive = [
            ctx.attr._symbiyosys_wrapper[DefaultInfo].default_runfiles.files,
            ctx.attr._symbiyosys_toolchain[DefaultInfo].default_runfiles.files,
            ctx.attr._yosys_toolchain[DefaultInfo].files,
            ctx.attr._yices_toolchain[DefaultInfo].files,
        ]),
    )
    return [DefaultInfo(executable = script, runfiles = runfiles)]


symbiyosys_test = rule(
    implementation = _symbiyosys_test_impl,
    doc = "Formal verification of (System) Verilog.",
    attrs = {
        "module": attr.label(
            doc = "Module to test.",
            mandatory = True,
            providers = [VerilogModuleInfo],
        ),
        "params": attr.string_dict(
            doc = "Verilog parameters for top module.",
        ),
        "modes": attr.string_list(
            doc = "Modes of verification.",
            mandatory = True,
            allow_empty = False,
        ),
        "depth": attr.int(
            doc = "Solver depth.",
            default = 20,
        ),
        "engine": attr.string(
            doc = "Verification engine.",
            default = "smtbmc",
        ),
        "_symbiyosys_wrapper": attr.label(
            doc = "Symbiyosys wrapper script.",
            default = Label("@rules_symbiyosys//symbiyosys/tools:symbiyosys_wrapper"),
            executable = True,
            cfg = "exec",
        ),
        "_symbiyosys_toolchain": attr.label(
            doc = "Symbiyosys toolchain.",
            default = Label("@symbiyosys_archive//:sby"),
            executable = True,
            cfg = "exec",
        ),
        "_yosys_toolchain": attr.label(
            doc = "Yosys toolchain.",
            default = Label("@rules_symbiyosys//symbiyosys/tools:yosys"),
        ),
        "_yices_toolchain": attr.label(
            doc = "Yices toolchain.",
            default = Label("@rules_symbiyosys//symbiyosys/tools:yices"),
        ),
    },
    test = True,
)


def _symbiyosys_trace_impl(ctx):
    # Run test to generate VCD directory / files.
    vcd_dir = ctx.actions.declare_directory("{}_vcd".format(ctx.label.name))

    args = ctx.actions.args()
    args.add("--vcd_dir")
    args.add(vcd_dir.path)
    args.add("--ignore_failure")

    ctx.actions.run(outputs = [vcd_dir], executable = ctx.executable.test, arguments = [args],
                    env = {
                        "RUNFILES_DIR": ctx.executable.test.path + ".runfiles",
                        "PATH": "/usr/local/bin:/usr/bin:/bin"
                    })

    # Wrap gtk_wrapper in order to bake in arguments.
    shell_cmd = [
        ctx.executable._gtkwave_wrapper.short_path,
        "--vcd_dir",
        vcd_dir.short_path,
        "--open_level",
        "1",
        "$@",
    ]
    shell_script = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.write(shell_script, " ".join(shell_cmd), is_executable = True)

    runfiles = ctx.runfiles(files = [vcd_dir])

    for attr in [ctx.attr._gtkwave_wrapper, ctx.attr.test]:
      runfiles = runfiles.merge(attr[DefaultInfo].default_runfiles)

    return [DefaultInfo(executable = shell_script, runfiles = runfiles)]


symbiyosys_trace = rule(
    implementation = _symbiyosys_trace_impl,
    doc = "View VCD trace from Symbiyosys.",
    attrs = {
        "test": attr.label(
            doc = "Symbiyosys test target to produce VCD file.",
            mandatory = True,
            executable = True,
            cfg = "exec",
        ),
        "_gtkwave_wrapper": attr.label(
            doc = "GTKwave wrapper script.",
            default = Label("@rules_verilog//gtkwave:gtkwave_wrapper"),
            executable = True,
            cfg = "exec",
        ),
    },
    executable = True,
)
