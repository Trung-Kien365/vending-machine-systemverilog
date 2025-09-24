`timescale 1ns/1ps

module test_bench;
  logic       i_clk;
  logic       i_rst_n;
  logic       i_nickle;
  logic       i_dime;
  logic       i_quarter;
  logic       o_soda;
  logic [2:0] o_change;

  // clock 100 MHz (10 ns period)
  initial i_clk = 0;
  always  #5 i_clk = ~i_clk;

  // reset task
  task automatic reset_dut();
    begin
      i_rst_n   = 0;
      i_nickle  = 0;
      i_dime    = 0;
      i_quarter = 0;
      repeat (2) @(posedge i_clk);
      i_rst_n = 1;
      @(posedge i_clk);
    end
  endtask

  // DUT: phải là FSM (trùng với RTL)
  FSM dut (
    .i_clk     (i_clk),
    .i_rst_n   (i_rst_n),
    .i_nickle  (i_nickle),
    .i_dime    (i_dime),
    .i_quarter (i_quarter),
    .o_soda    (o_soda),
    .o_change  (o_change)
  );

  // chèn 1 đồng trong 1 chu kỳ clock
  task automatic insert_coin(input logic n, d, q);
    begin
      i_nickle  = n;
      i_dime    = d;
      i_quarter = q;
      @(posedge i_clk);           // giữ 1 chu kỳ
      i_nickle  = 0;
      i_dime    = 0;
      i_quarter = 0;
      @(posedge i_clk);           // cho DUT cập nhật state/output
    end
  endtask

  // --- Test sequences ---
  initial begin
    // (Tùy chọn) ghi VCD – ModelSim vẫn chạy bình thường nếu bỏ hai dòng này
    $dumpfile("test_bench.vcd");
    $dumpvars(0, test_bench);     // scope phải đúng tên top: test_bench

    reset_dut();

    // TC1: 5+5+5+5 = 20
    $display("==== TC1: 4 nickles (20c) ====");
    insert_coin(1,0,0);
    insert_coin(1,0,0);
    insert_coin(1,0,0);
    insert_coin(1,0,0);
    assert(o_soda && o_change == 3'b000)
      else $error("FAIL TC1: o_soda=%b o_change=%0d", o_soda, o_change);

    // TC2: 5+5+10 = 20
    $display("==== TC2: 5+5+10 (20c) ====");
    insert_coin(1,0,0);
    insert_coin(1,0,0);
    insert_coin(0,1,0);
    assert(o_soda && o_change == 3'b000)
      else $error("FAIL TC2: o_soda=%b o_change=%0d", o_soda, o_change);

    // TC3: 10+5+5 = 20
    $display("==== TC3: 10+5+5 (20c) ====");
    insert_coin(0,1,0);
    insert_coin(1,0,0);
    insert_coin(1,0,0);
    assert(o_soda && o_change == 3'b000)
      else $error("FAIL TC3: o_soda=%b o_change=%0d", o_soda, o_change);

    // TC4: 5+10+5 = 20
    $display("==== TC4: 5+10+5 (20c) ====");
    insert_coin(1,0,0);
    insert_coin(0,1,0);
    insert_coin(1,0,0);
    assert(o_soda && o_change == 3'b000)
      else $error("FAIL TC4: o_soda=%b o_change=%0d", o_soda, o_change);

    // TC5: 10+10 = 20
    $display("==== TC5: 10+10 (20c) ====");
    insert_coin(0,1,0);
    insert_coin(0,1,0);
    assert(o_soda && o_change == 3'b000)
      else $error("FAIL TC5: o_soda=%b o_change=%0d", o_soda, o_change);

    // TC6: 5+5+5+10 = 25 → thối 5
    $display("==== TC6: 5+5+5+10 (25c) ====");
    insert_coin(1,0,0);
    insert_coin(1,0,0);
    insert_coin(1,0,0);
    insert_coin(0,1,0);
    assert(o_soda && o_change == 3'b001)
      else $error("FAIL TC6: o_soda=%b o_change=%0d", o_soda, o_change);

    // TC7: 10+5+10 = 25 → thối 5
    $display("==== TC7: 10+5+10 (25c) ====");
    insert_coin(0,1,0);
    insert_coin(1,0,0);
    insert_coin(0,1,0);
    assert(o_soda && o_change == 3'b001)
      else $error("FAIL TC7: o_soda=%b o_change=%0d", o_soda, o_change);

    // TC8: 25 = 25 → không thối (tùy yêu cầu; RTL hiện trả 0)
    $display("==== TC8: 1 quarter (25c) ====");
    insert_coin(0,0,1);
    assert(o_soda && o_change == 3'b000)
      else $error("FAIL TC8: o_soda=%b o_change=%0d", o_soda, o_change);

    // TC9: 5+25 = 30 → thối 10
    $display("==== TC9: 5+25 (30c) ====");
    insert_coin(1,0,0);
    insert_coin(0,0,1);
    assert(o_soda && o_change == 3'b010)
      else $error("FAIL TC9: o_soda=%b o_change=%0d", o_soda, o_change);

    // TC10: 5+5+25 = 35 → thối 10
    $display("==== TC10: 5+5+25 (35c) ====");
    insert_coin(1,0,0);
    insert_coin(1,0,0);
    insert_coin(0,0,1);
    assert(o_soda && o_change == 3'b010)
      else $error("FAIL TC10: o_soda=%b o_change=%0d", o_soda, o_change);

    // TC11: 10+25 = 35 → thối 10
    $display("==== TC11: 10+25 (35c) ====");
    insert_coin(0,1,0);
    insert_coin(0,0,1);
    assert(o_soda && o_change == 3'b010)
      else $error("FAIL TC11: o_soda=%b o_change=%0d", o_soda, o_change);

    // TC12: 5+5+5+25 = 40 → thối 20
    $display("==== TC12: 5+5+5+25 (40c) ====");
    insert_coin(1,0,0);
    insert_coin(1,0,0);
    insert_coin(1,0,0);
    insert_coin(0,0,1);
    assert(o_soda && o_change == 3'b100)
      else $error("FAIL TC12: o_soda=%b o_change=%0d", o_soda, o_change);

    // TC13: 5+10+25 = 40 → thối 20
    $display("==== TC13: 5+10+25 (40c) ====");
    insert_coin(1,0,0);
    insert_coin(0,1,0);
    insert_coin(0,0,1);
    assert(o_soda && o_change == 3'b100)
      else $error("FAIL TC13: o_soda=%b o_change=%0d", o_soda, o_change);

    // TC14: 10+5+25 = 40 → thối 20
    $display("==== TC14: 10+5+25 (40c) ====");
    insert_coin(0,1,0);
    insert_coin(1,0,0);
    insert_coin(0,0,1);
    assert(o_soda && o_change == 3'b100)
      else $error("FAIL TC14: o_soda=%b o_change=%0d", o_soda, o_change);

    $display("==== All testcases finished ====");
    $finish;
  end

  // Monitor
  initial begin
    $monitor("T=%0t | rst=%0b n=%0b d=%0b q=%0b -> o_soda=%0b o_change=%0d",
              $time, i_rst_n, i_nickle, i_dime, i_quarter, o_soda, o_change);
  end
endmodule
