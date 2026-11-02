# 新会话开场提示词（SV / FPGA 阶段，复制这段给新的 AI 会话）

我在做 **W5+：SystemVerilog 验证 + FPGA 上手**。练习仓库在 `C:\Users\jyd10\Desktop\question\sv-lab`（git，已推 GitHub `mioqiang/sv-lab`）。

**请先读这几个文件，不要让我重新贴代码：**
- `sv-lab/notes/progress.md`（进度：SV 学到《SV 验证：测试平台编写指南》第 4 章末尾）
- `sv-lab/notes/toolchain.md`（XSim 特性支持矩阵 8/8 + 三个坑，必读）
- `sv-lab/notes/plan.md`（当前任务 T1/T2/T3 与验收标准）
- `sv-lab/README.md`（含红线，见下）
- 参考：`C:\Users\jyd10\Desktop\codex\codex_重排逐周表_W2-W22_后端主攻.md` 的 W5 一节

---

## 硬约束（违反就不要做）

1. **`D:\Vivado2024.2\AC880\` 下的 Vivado 工程只读**：不移动、不改名、不删、不往里加文件。
   也不要在里面**执行**任何命令——`xvlog/xelab/xsim` 会写 `xsim.dir/`、`*.log`，
   **Vivado GUI 一打开工程就会写 `.cache/`、`.hw/`**，等于改了原件。
2. 所有实验在 `sv-lab\` 下做；T1 用仓库里的副本 `sv-lab\mux2\`（已从 AC880 复制）。
3. 需要新建 Vivado 工程时建在 `sv-lab\vivado\`，不要建在 `AC880` 里。
4. 不要再装第二套仿真器（XSim 够用，装环境是时间黑洞）。

## 我的环境

- Windows 10/11；Vivado ML 2024.2 装在 `D:\Vivado2024.2\Vivado\2024.2\`
- **唯一仿真器是 XSim v2024.2.0**；iverilog / verilator / ModelSim / Quartus 都没装
- 命令行三步（**必须 `-sv`**，源文件**不能带 UTF-8 BOM**）：

  ```powershell
  $bin = 'D:\Vivado2024.2\Vivado\2024.2\bin'
  & "$bin\xvlog.bat" -sv <files>.sv
  & "$bin\xelab.bat" -sv <top> -s <snapshot>
  & "$bin\xsim.bat" <snapshot> -runall
  ```

- 器件：`xc7z020clg484-2`（Zynq-7020）；板子型号 AC880（板子手册还没细看，PS/PL 流程待确认）
- Tcl 那条线另有仓库 `C:\Users\jyd10\Desktop\question\tcl-practice`：**已收口**
  （53 条断言全绿、三份基线 `fc` 全 0），本周不动它，别把时间花回去。

## 我的学习方式（重要，请遵守）

- **我自己写代码，你不要直接给答案**；给我语法用法、思路提示、验收标准
- 我卡住时贴报错或仿真输出，你帮我定位根因（尽量用**可运行的最小演示**验证，别只讲理论）
- 每次改完我会 `Ctrl+S` 保存——报错和我贴的代码对不上时请先怀疑这个
- 你验收时按 `sv-lab/notes/plan.md` 的验收标准 + 仿真输出（`TEST PASSED`、`$error` 计数、退出码）
- 不要一次给我整份 TB：先给结构和断言清单，我写完你再查

## 我在 SV 里容易犯的错（请主动提醒）

1. 忘保存；忘了加 `-sv`（报 `root scope declaration is not allowed in Verilog 95/2K mode`，看着像"不支持 SV"）
2. 源文件带了 UTF-8 BOM（`xvlog` 报 `unexpected non-printable character ... '0xef'`）
3. `always_ff` / `always_comb` 里用错赋值：时序用 `<=`，组合用 `=`
4. clocking block 里驱动用 `=`（应 `cb.xxx <= 值`），采样忘了 `@(cb)` 或 `cb.xxx`
5. `interface` 忘了 `modport` 或方向写反（dut 侧 input、tb 侧 output）
6. `class` 句柄没 `new()` 就调方法（null 句柄）
7. 自检只用 `$display`，没有 `$error`；或者 `$error` 之后不 `$fatal`，仿真跑飞
8. TB 里 `#10` 与 `@(posedge clk)` 混用，采样错拍（这正是第 4 章要消除的 race）

## 我的进度与今天的任务

进度：SV 语法基本过完；《SV 验证》第 1–4 章读完（interface / modport / clocking block /
program / 竞争与 race）；`class` 会写但没在 TB 里用过。FPGA 侧刚起步（Vivado 装好，`mux2` 跑过简单仿真）。

**今天的任务（按顺序，别跳；详见 `notes/plan.md`）**：

1. **T1（90 min）**：写 `sv-lab\mux2\mux2_if.sv`（interface + modport）+ `mux2_tb.sv`
   （`clocking cb` 驱动、≥3 条 `$error` 自检、末尾打印 `TEST PASSED`），三步命令跑通；
   再写一版不用 clocking block 的对照，说明采样差一拍在哪。
2. **T2（60 min）**：第 5 章 5.1–5.3，把激励封装成 `class Stim`（句柄 vs 对象、`new()`、方法）。
3. **T3（60–90 min）**：把 `AC880\mux2` **复制**到 `sv-lab\vivado\mux2\`，在副本上综合，
   记录 LUT / FF / IO 三个数字。

## 本周明确不做

- UVM（W15 再说）、覆盖率的"数字分析"（第 9 章再学）
- PS 侧软件开发（Vitis / 裸机 C），除非板子手册要求
- 真实 OpenROAD / OpenSTA 报告适配（W18）
- 回头迭代 Tcl 解析器
