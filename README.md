# sv-lab —— SystemVerilog / FPGA 动手练习

配套：`tcl-practice`（Tcl EDA 报告解析器，W3–W4）、`my-ic-journey`（学习路线，不放代码）。

## 目录

```text
sv-lab/
├── README.md            ← 本文件（含红线）
├── NEXT-SESSION.md      ← 新会话开场提示词（复制给新对话用）
├── notes/
│   ├── toolchain.md     ← 本机工具链 + XSim 的 SV 支持矩阵（实测）+ 三个坑
│   ├── progress.md      ← 学习进度（时间线 / 已有能力 / 下一段）
│   └── plan.md          ← 当前阶段的任务表与验收标准
└── probe/               ← 仿真器能力探针（8 个特性各一条），换工具/Vivado 升级后重跑
    ├── p1_logic.sv … p8_covergroup.sv
    ├── probe.ps1        （第一版，有 BOM bug，留作对照）
    └── probe2.ps1       （可用版：去 BOM + 逐个编译 + 端到端跑 class）
```

## 环境（本机）

- Vivado ML 2024.2，`D:\Vivado2024.2\Vivado\2024.2\`
- 仿真器只有 XSim：`xvlog` → `xelab` → `xsim`（**必须加 `-sv`**）
- 器件：`xc7z020clg484-2`（Zynq-7020）

## 跑一个例子

```powershell
$bin = 'D:\Vivado2024.2\Vivado\2024.2\bin'
& "$bin\xvlog.bat" -sv <files>.sv
& "$bin\xelab.bat" -sv <top> -s <snapshot>
& "$bin\xsim.bat" <snapshot> -runall
```

## 约定

- 新文件一律 `.sv`，UTF-8 **无 BOM**
- 每个练习带自检：`$error` 报错不终止、`$fatal` 收尾
- 每个模块至少 3 条自检；能打印 `TEST PASSED` 才算过
- `xsim.dir/`、`*.log`、`*.jou`、`*.pb` 不入库（见 `.gitignore`）

## 红线（硬约束，2026-11-02 定）

> **`D:\Vivado2024.2\AC880\` 下的工程只读。**
> 不移动、不改名、不删、不往里加文件——包括 `mux2.xpr`、`mux2.srcs\`、`mux2.cache\` 等一整套。

- 原因：那是 Vivado GUI 工程，`.xpr` 里记着相对路径，外面动一个文件就可能让工程打不开；而且它属于课程/板卡示例，保持原样最好。
- **需要拿它做实验时**：从本仓库的副本开始——`sv-lab\mux2\mux2.v`、`sv-lab\mux2\mux2_tb.v` 已经从那里复制出来了，T1 就在副本上改。
- **需要新建 Vivado 工程时**：建在 `sv-lab\vivado\` 下（不要建在 `AC880` 里），并且大文件不进 git。
- 只读的含义也包括：**不要**在那个目录里跑会生成文件的命令（`xvlog`/`xelab`/`xsim` 会写 `xsim.dir`、`*.log`），命令一律在 `sv-lab` 下执行。
