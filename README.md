### Counter Module

This Verilog module implements a flexible and configurable counter that can be used in various digital applications, such as in timing, event counting, or signal generation. The counter is parameterized by a bit-width `N` (default 8 bits), which defines the size of the counter. It supports both counting up and counting down, as well as features like overflow detection, asynchronous reset, and enable/clear functionality.

#### Parameters:
- `N`: Defines the width of the counter. It is a parameterized value, and by default, it is set to 8 bits. The counter will operate within the range of 0 to \(2^N - 1\).

#### Inputs:
- `clk`: The clock signal that triggers the counter’s operation on each rising edge. The counter's state is updated synchronously with the clock.
- `rst_n`: The active low reset signal. When `rst_n` is low, the counter is reset to zero, and the overflow flag is cleared. This allows for an easy initialization of the counter state.
- `count_en`: The count enable signal. When `count_en` is low, the counter halts, holding its current value. When high, the counter is enabled to increment or decrement based on the `count_dir` input.
- `count_clr`: The active high clear signal. When `count_clr` is asserted, the counter is reset to zero regardless of other inputs.
- `count_dir`: The direction control signal. When high, the counter increments (counts up); when low, it decrements (counts down).

#### Outputs:
- `overflow`: This signal indicates an overflow condition. An overflow occurs when the counter reaches its maximum value while counting up (when `count_dir` is high) or its minimum value while counting down (when `count_dir` is low).
- `count`: The current value of the counter. This is an `N`-bit wide register that stores the current count.

#### Functionality:
The counter module operates based on the clock (`clk`), reset (`rst_n`), enable (`count_en`), clear (`count_clr`), and direction (`count_dir`) inputs:

1. **Reset and Initialization**: When `rst_n` is low, the counter is asynchronously reset to zero, and the overflow flag is cleared. This ensures that the counter starts from a known state.
   
2. **Counting Mechanism**: The counter value is updated on every rising edge of the clock. If `count_en` is high, the counter either increments or decrements depending on the value of `count_dir`:
   - When `count_dir` is high, the counter increments.
   - When `count_dir` is low, the counter decrements.
   
3. **Overflow Detection**: The overflow signal is asserted when the counter reaches the maximum value (when counting up) or the minimum value (when counting down) while counting is enabled (`count_en` is high). The overflow flag will reset when the counter is manually cleared or reset.

4. **Clear Function**: The `count_clr` signal can be used to clear the counter. When `count_clr` is high, the counter is reset to zero, regardless of the enable or direction signals.

This counter module is highly versatile and can be used in a wide range of applications where simple counting functionality with flexibility and control is required, such as in timers, counters for event-based systems, or in generating specific timing signals.
