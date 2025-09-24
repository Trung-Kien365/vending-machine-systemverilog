# vending-machine-systemverilog
# Thiết kế Máy Bán Hàng Tự Động (Vending Machine)

## Giới thiệu chung
Đây là trong bài tập trong môn học **Computer Architecture** với mục tiêu là thiết kế một máy bán hàng tự động.
Máy nhận các đồng xu ¢5 (Nickel), ¢10 (Dime), ¢25 (Quarter) và sẽ xuất **soda** khi số tiền đạt từ ¢20 trở lên, đồng thời tính toán và trả lại tiền thừa.

---
## Qui trình làm
- Trước hết, phải biết viết code Verilog/System Verilog cơ bản để làm.
- Bước 1, vẽ sơ đồ trạng thái máy mealy.
- Bước 2, thực hiện vẽ sơ đồ phân cứng.
- Bước 3, Triển khai viết lệnh System Verilog cho phân cứng thiết kế ở Bước 2.
- Cuối cùng, viết những testcase đảm bảo qua các trường hợp, và 1 số trường hợp đặc biệt.
---
## Yêu cầu hệ thống
- Hệ thống nhận một đồng xu duy nhất mỗi chu kỳ (¢5, ¢10 hoặc ¢25).
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
## Một số khó khăn khi làm dự án
- Riêng trong dự án này thiết kế chạy theo fsm mealy, cho nên ngõ ra phải phụ thuộc vào ngõ vào và trạng thái hiện tại.
- Thiết kế này được thiết kế theo trạng thái máy fsm mealy, nên số trạng thái của nó nhỏ hơn số trạng thái của moore fsm.
- Các trạng thái được mã hóa thành các trường hợp của tiền thừa:
  - `000` = ¢0  
  - `001` = ¢5  
  - `010` = ¢10  
  - `011` = ¢15  
  - `100` = ¢20
---
## Công cụ sử dụng
- Ngôn ngữ: **SystemVerilog**
- IDE/Simulator: **ModelSim / Quartus**
- Coding Style: [lowRISC Verilog/SystemVerilog Style Guide](https://github.com/lowRISC/style-guides/blob/master/VerilogCodingStyle.md)

---



