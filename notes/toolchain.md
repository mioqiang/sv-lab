# 工具链现状（2026-11-02 实测）

## 本机装了什么

| 工具 | 路径 / 版本 | 说明 |
|---|---|---|
| **Vivado ML 2024.2** | `D:\Vivado2024.2\Vivado\2024.2\` | 159 GB，含 Vivado IDE / XSim / Vitis / Vitis HLS / Model Composer / DocNav |
| **XSim**（Vivado 自带仿真器） | 同目录 `bin\xvlog.bat` `xelab.bat` `xsim.bat` | `Vivado Simulator v2024.2.0`，已验证可跑 |
| 已有工程 | `D:\Vivado2024.2\AC880\mux2\mux2.xpr` | 器件 **xc7z020clg484-2**（Zynq-7020），`mux2.v` + `mux2_tb.v` |
| 安装包残留 | `D:\Xilinx`（93 GB） | 解包出来的安装文件，装完可删（**别删 `D:\Vivado2024.2`**） |

**没有**：iverilog / verilator / ModelSim / Questa / Quartus / GTKWave / Yosys（PATH 全部查过）。

结论：**本地唯一可用的 SV 仿真器是 XSim**，第 4/5 章的练习全部在本地做，不需要 EDA Playground。

## SV 特性支持矩阵（xvlog 实测）

探针文件在 `probe/p1..p8_*.sv`，每个只测一个特性。

| 探针 | 特性 | 对应章节 | 结果 |
|---|---|---|---|
| p1_logic | `logic` / `always_ff` | 第 2 章 | **OK** |
| p2_interface | `interface` + `modport` | 第 4 章 | **OK** |
| p3_clocking | `clocking ... @(posedge clk)` | 第 4 章 | **OK** |
| p4_program | `program automatic` | 第 4 章 | **OK** |
| p5_vif | `virtual interface` 句柄 | 第 4 章 | **OK** |
| p6_class | `class` / `new()` / 方法 | 第 5 章 | **OK**（端到端跑出 `class ok n=1`） |
| p7_rand | `rand` / `randomize()` | 第 6 章 | **OK** |
| p8_covergroup | `covergroup` | 第 9 章 | **OK**（编译通过） |

功能覆盖率：`xelab`/`xsim` 都有 `--cov_db_dir` / `--cov_db_name` / `--ignore_coverage` 开关，
说明有功能覆盖率数据库支持，但**报告能不能出数还没实测**——第 9 章到时再验证。

## 三个坑（都实际踩过）

1. **必须加 `-sv`**
   不加时 xvlog 按 Verilog-2001 解析，报 `root scope declaration is not allowed in Verilog 95/2K mode`
   或 `syntax error near 'input'`——**看起来像"不支持 SV"，其实只是没开模式**。

2. **源文件不能有 UTF-8 BOM**
   报 `unexpected non-printable character with the hex value '0xef'`。
   VS Code 存 UTF-8（无 BOM）没问题；但 PowerShell 的 `Set-Content -Encoding UTF8` **会加 BOM**。

3. **命令行三步**（GUI 里等价于 Run Simulation）

   ```powershell
   $bin = 'D:\Vivado2024.2\Vivado\2024.2\bin'
   & "$bin\xvlog.bat" -sv dut.sv tb.sv
   & "$bin\xelab.bat" -sv tb_top -s sim_tb
   & "$bin\xsim.bat" sim_tb -runall
   ```

## 复跑探针

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\probe\probe2.ps1
```

`probe/probe.ps1` 是第一版（有 BOM bug，留作对照）；`probe2.ps1` 会自动去 BOM 再逐个编译。
