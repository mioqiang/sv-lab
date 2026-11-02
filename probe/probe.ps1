$ErrorActionPreference = 'Continue'
$bin = 'D:\Vivado2024.2\Vivado\2024.2\bin'
$work = 'C:\Users\jyd10\Desktop\question\.sv-probe'
if (-not (Test-Path $work)) { New-Item -ItemType Directory -Path $work | Out-Null }
Set-Location $work

# ---- 探针文件 ----
@'
module p1 (input logic clk, input logic d, output logic q);
  always_ff @(posedge clk) q <= d;
endmodule
'@ | Set-Content -Encoding UTF8 p1_logic.sv

@'
interface bus_if (input logic clk);
  logic       valid;
  logic [7:0] data;
  modport tb  (input clk, output valid, output data);
  modport dut (input clk, input valid, input data);
endinterface
'@ | Set-Content -Encoding UTF8 p2_interface.sv

@'
interface cb_if (input logic clk);
  logic valid;
  clocking cb @(posedge clk);
    default input #1step output #1;
    output valid;
  endclocking
endinterface
'@ | Set-Content -Encoding UTF8 p3_clocking.sv

@'
program automatic p4;
  initial begin
    $display("program ok");
  end
endprogram
'@ | Set-Content -Encoding UTF8 p4_program.sv

@'
interface vif_if;
  logic a;
endinterface
class C;
  virtual vif_if vif;
endclass
'@ | Set-Content -Encoding UTF8 p5_vif.sv

@'
class Stim;
  int n;
  function new(); n = 0; endfunction
  function void send(); n++; endfunction
endclass
module p6;
  initial begin
    Stim s = new();
    s.send();
    $display("class ok n=%0d", s.n);
  end
endmodule
'@ | Set-Content -Encoding UTF8 p6_class.sv

@'
class Pkt;
  rand bit [7:0] addr;
endclass
module p7;
  initial begin
    Pkt p = new();
    void'(p.randomize());
    $display("rand ok addr=%0d", p.addr);
  end
endmodule
'@ | Set-Content -Encoding UTF8 p7_rand.sv

@'
module p8;
  logic [1:0] v;
  covergroup cg @(posedge v[0]);
    coverpoint v;
  endgroup
  cg c = new();
endmodule
'@ | Set-Content -Encoding UTF8 p8_covergroup.sv

# ---- 逐个编译 ----
"=== xvlog 编译结果 ==="
$rows = @()
foreach ($f in Get-ChildItem *.sv | Sort-Object Name) {
    $out = (& "$bin\xvlog.bat" $f.Name 2>&1) -join "`n"
    $code = $LASTEXITCODE
    $err = if ($out -match 'ERROR') { ($out -split "`n" | Where-Object { $_ -match 'ERROR' } | Select-Object -First 1).Trim() } else { '' }
    $status = if ($code -eq 0 -and $err -eq '') { 'OK' } else { 'FAIL' }
    $rows += [pscustomobject]@{ 特性 = $f.BaseName; 编译 = $status; 退出码 = $code; 首个错误 = $err }
}
$rows | Format-Table -AutoSize -Wrap | Out-String -Width 200

# ---- 串起来跑一遍（class + program）----
"=== 端到端：xelab + xsim（class/module 版）==="
$out = (& "$bin\xelab.bat" p6 -s sim_p6 2>&1) -join "`n"
if ($LASTEXITCODE -eq 0) {
    (& "$bin\xsim.bat" sim_p6 -runall 2>&1) -join "`n"
} else {
    "xelab 失败：" + (($out -split "`n" | Where-Object { $_ -match 'ERROR' } | Select-Object -First 2) -join ' | ')
}
