# vending-machine-systemverilog
# Task Bán Hàng Tự Động (Vending Machine)

## Giới thiệu chung
Đây là trong bài tập **Milestone 1 - Computer Architecture** với mục tiêu thiết kế một máy bán hàng tự động
Máy có thể nhận các đồng xu ¢5 (Nickel), ¢10 (Dime), ¢25 (Quarter) và sẽ xuất **soda** khi số tiền đạt từ ¢20 trở lên, đồng thời tính toán và trả lại tiền thừa.

---

## Mục tiêu
- Ôn tập và áp dụng kiến thức về **thiết kế logic cơ bản** và **FSM**.
- Thiết kế **bộ điều khiển máy bán hàng** hoạt động chính xác theo yêu cầu.

---

## Yêu cầu hệ thống
- Nhận một đồng xu duy nhất mỗi chu kỳ (¢5, ¢10 hoặc ¢25).
- Khi tổng tiền ≥ ¢20 → Xuất 1 lon soda.
- Trả lại tiền thừa (o_change) ở dạng 3-bit:
  - `000` = ¢0  
  - `001` = ¢5  
  - `010` = ¢10  
  - `011` = ¢15  
  - `100` = ¢20  

---

## Ví dụ hoạt động
Người dùng nhập lần lượt: **¢10 (dime) + ¢25 (quarter)**.  
→ Tổng = ¢35.  
→ Máy xuất **soda** và trả lại **¢15** (mã `011`).

---

## Công cụ sử dụng
- Ngôn ngữ: **SystemVerilog**
- IDE/Simulator: **ModelSim / Quartus**
- Coding Style: [lowRISC Verilog/SystemVerilog Style Guide](https://github.com/lowRISC/style-guides/blob/master/VerilogCodingStyle.md)

---



