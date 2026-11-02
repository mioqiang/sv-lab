# 明天的任务（2026-11-03）

工具链前提：`notes/toolchain.md` —— 本地只有 XSim，**第 4/5 章全部在本地做**，不用 EDA Playground。

| 时间 | 任务 | 验收标准 |
|---|---|---|
| **90 min** | **T1：把 `mux2_tb.v` 重写成 SV 版**——新建 `mux2_if.sv`（interface + modport）+ 新 TB（`clocking cb` 驱动、`$error` 自检） | ① `xvlog -sv` → `xelab -sv` → `xsim -runall` 三步通过<br>② 打印 `TEST PASSED`、退出码 0<br>③ 对比"用 / 不用 clocking block"的采样差一拍 |
| **60 min** | **T2：第 5 章 OOP 开篇**（只读 5.1–5.3），把 T1 的激励封装成 `class Stim` | 能说清两件事：`Stim a=new(); Stim b=a;` 改 `b` 后 `a` 看不看得到；只声明不 `new` 就调方法报什么错 |
| **60–90 min** | **T3：Vivado GUI 线**——在 `mux2.xpr` 里综合、看资源占用（器件 xc7z020clg484-2） | 综合通过 + 记录 LUT / FF / IO 三个数字 |

## T1 的现成载体

`D:\Vivado2024.2\AC880\mux2\mux2.srcs\`：
- `sources_1\new\mux2.v` —— `assign out = (sel == 0) ? a : b;`
- `sim_1\new\mux2_tb.v` —— 纯 `#20` 延时激励，**没有任何自检**

不用新造模块：把 TB 换成 interface + clocking + `$error` 版本，正好把第 4 章全部用上。

## T1 的命令模板

```powershell
$bin = 'D:\Vivado2024.2\Vivado\2024.2\bin'
cd <实验目录>
& "$bin\xvlog.bat" -sv mux2.v mux2_if.sv mux2_tb.sv
& "$bin\xelab.bat" -sv mux2_tb -s sim_mux2
& "$bin\xsim.bat" sim_mux2 -runall
```

## 明天不要做

1. 不回头改 Tcl（`tcl-practice` 已收口：53/0 + 基线 3/3）
2. 不一次读完第 5 章（一次 3 小节，配合改 TB）
3. 不装第二套工具链（XSim 够用）

## 待确认

- **AC880 板子手册**：器件是 Zynq-7020，板上有 ARM PS 侧；要确认是"纯 PL 点灯"还是"PS+PL"，决定 T3 是直接烧 PL 还是走 Vitis。
- 板子是否在手边：不在就只做"综合 + 资源/时序报告"。
