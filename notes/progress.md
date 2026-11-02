# SV / FPGA 进度（2026-11-02）

## 时间线

| 时间 | 内容 | 状态 |
|---|---|---|
| 2026.10.12–10.25 | Tcl：日志/时序报告解析器 v1（`tcl-practice` 仓库） | **完成**：53 条断言、9 条格式变体、批量 + CSV、`parser-design.md` |
| 2026.10 中下旬起 | SystemVerilog 语法学习 | 进行中 |
| 2026.11 初 | 《SystemVerilog 验证：测试平台编写指南》第 1–**4 章末尾** | **到第 4 章末尾**：interface / modport / clocking block / program / 竞争与 race |
| 2026.11 初 | FPGA 动手（Vivado 2024.2 + Zynq-7020） | 起步：`mux2` 工程建好，RTL + 简单 TB 跑过 |

## 已经具备的能力

- 能用 `interface` + `modport` 描述 DUT 与 TB 之间的总线，并分方向
- 知道 `clocking block` 解决什么问题（采样/驱动的时序竞争），能说出"不用它差一拍"
- 知道 `program block` 的用途（TB 与 RTL 分区，避免竞争）
- `class` 的基础：句柄 vs 对象、`new()`、方法
- 能跑通 XSim 的编译-细化-仿真三步（`xvlog` → `xelab` → `xsim`）

## 下一段要补的

1. **第 5 章 OOP**（只到 5.3：class / new() / 句柄 / 方法 / static）
2. **把第 4 章落到真实 DUT 上**：interface + clocking 驱动 `mux2`，并加 `$error` 自检
3. **FPGA 侧**：Vivado 综合 → 资源占用 → （板子在手时）上板

## 与周表的对照

周表 W5（10.26–11.01）要求的 RTL 顺序是：环境 → 参数化 MUX → 译码器 → 计数器 → 移位寄存器，
每个模块配 `$error`/`$fatal` 自检 TB。**目前 SV 理论在同一条线的前面，RTL 动手在后面**，
所以接下来不是再往前读，而是**用第 4/5 章去重写已有模块的 TB**（`mux2_tb.v` 目前没有任何自检）。
