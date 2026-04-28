# Design Sources — `Binary_Perception_Game.srcs/sources_1/`

This directory contains all synthesisable VHDL source files for the Binary Perception Game, targeting the **Digilent Nexys A7-50T** (`xc7a50ticsg324-1L`).

For the full project description, game rules and architecture overview see the [root README](../../README.md).

📁 [Root README](../../../README.md) · 📁 [Simulations README](../../sim_1/new/README.md)
---

## Files in `new/`

| File | Entity | Purpose |
|------|--------|---------|
| `Binary_Perception_Game.vhd` | `Binary_Perception_Game_Top` | Top-level — wires all components together |
| `Main_Game_logic.vhd` | `Main_Game_logic` | 4-state FSM + 0.1 s resolution timer |
| `Multiplexor.vhd` | `Multiplexor` | 8-digit time-division display multiplexer |
| `bin_2_bcd.vhd` | `bin_2_bcd` | 8-bit binary → 3-digit BCD converter |
| `bin_2_seg.vhd` | `bin_2_seg` | 4-bit BCD → 7-segment look-up table |

## Files in `imports/`

These components were developed and tested in earlier lab exercises and imported into this project unchanged.

| File | Entity | Purpose |
|------|--------|---------|
| `clk_en.vhd` | `clk_en` | Generates a 1 ms clock-enable pulse from 100 MHz |
| `counter.vhd` | `counter` | Free-running 8-bit counter (random source) |
| `debounce.vhd` | `debounce` | 10 ms stable-window button debouncer |

---

## Entity Interfaces

### `Binary_Perception_Game_Top`
Top-level entity. All port names match the Nexys A7 XDC constraint file exactly.

```vhdl
entity Binary_Perception_Game_Top is
    Port (
        clk        : in  STD_LOGIC;                      -- 100 MHz system clock
        rst        : in  STD_LOGIC;                      -- CPU_RESETN (active-low on board)
        btnc       : in  STD_LOGIC;                      -- Start / next round
        btnr       : in  STD_LOGIC;                      -- Software reset (active-high)
        sw         : in  STD_LOGIC_VECTOR (7 downto 0);  -- Player binary input
        led        : out STD_LOGIC_VECTOR (7 downto 0);  -- SW mirror (live feedback)
        seg        : out STD_LOGIC_VECTOR (6 downto 0);  -- Segment bus (CA–CG)
        dp         : out STD_LOGIC;                      -- Decimal point
        an         : out STD_LOGIC_VECTOR (7 downto 0)   -- Anode enables (active-low)
    );
end Binary_Perception_Game_Top;
```

> **Reset polarity:** `rst` (CPU_RESETN) is active-low on the board. The top level inverts it internally: `s_rst <= not rst or btnr`. All sub-components receive the active-high `s_rst` signal.

---

### `Main_Game_logic`

```vhdl
entity Main_Game_logic is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;                       -- active-high
        ce_1ms     : in  std_logic;                       -- 1 ms clock enable
        btn_start  : in  std_logic;                       -- debounced BTNC pulse
        match      : in  std_logic;                       -- SW == target
        target_en  : out std_logic;                       -- one-cycle latch pulse (S_GEN)
        show_time  : out std_logic;                       -- '1' in S_WIN
        time_bcd_h : out std_logic_vector(3 downto 0);   -- timer hundreds digit
        time_bcd_t : out std_logic_vector(3 downto 0);   -- timer tens digit
        time_bcd_u : out std_logic_vector(3 downto 0)    -- timer units digit
    );
end Main_Game_logic;
```

**FSM states:**

```
S_IDLE ──(btn_start)──► S_GEN ──(1 cycle)──► S_RUN ──(match)──► S_WIN
  ▲                                                                  │
  └───────────────────────────(btn_start)───────────────────────────┘
```

| State | `target_en` | `show_time` | Timer |
|-------|:-----------:|:-----------:|-------|
| S_IDLE | `0` | `0` | Reset to 0 |
| S_GEN  | `1` | `0` | Reset to 0 |
| S_RUN  | `0` | `0` | Counting (0.1 s steps, max 99.9 s) |
| S_WIN  | `0` | `1` | Frozen |

---

### `Multiplexor`

```vhdl
entity Multiplexor is
    Port (
        clk       : in  STD_LOGIC;
        ce_1ms    : in  STD_LOGIC;                        -- advances display slot
        show_time : in  STD_LOGIC;                        -- '1' = S_WIN mode
        user_u/t/h : in STD_LOGIC_VECTOR(3 downto 0);    -- right-side BCD digits
        left_u/t/h : in STD_LOGIC_VECTOR(3 downto 0);    -- left-side BCD digits
        an        : out STD_LOGIC_VECTOR(7 downto 0);     -- anode enables
        mux_out   : out STD_LOGIC_VECTOR(3 downto 0);    -- digit to bin_2_seg
        dp        : out STD_LOGIC
    );
end Multiplexor;
```

Cycles through 8 slots at 1 ms each (~125 Hz per digit). Only 6 slots are active — slots `011` and `100` are left blank (gap between left and right display groups).

| `cnt` | Anode | Digit shown |
|:-----:|:-----:|-------------|
| `000` | AN0 | `user_u` — units |
| `001` | AN1 | `user_t` — tens, DP active in S_WIN |
| `010` | AN2 | `user_h` — hundreds |
| `101` | AN5 | `left_u` — target units (S_WIN only) |
| `110` | AN6 | `left_t` — target tens (S_WIN only) |
| `111` | AN7 | `left_h` — target hundreds (S_WIN only) |

During `S_RUN`, `user_*` carries the live switch value in BCD. During `S_WIN`, `user_*` carries the frozen elapsed time.

---

### `bin_2_bcd`

```vhdl
entity bin_2_bcd is
    Port (
        bin_in : in  STD_LOGIC_VECTOR(7 downto 0);  -- 0–255
        hun    : out STD_LOGIC_VECTOR(3 downto 0);   -- hundreds digit
        ten    : out STD_LOGIC_VECTOR(3 downto 0);   -- tens digit
        uni    : out STD_LOGIC_VECTOR(3 downto 0)    -- units digit
    );
end bin_2_bcd;
```

Purely combinational. Two instances are used in the top level: one converts the latched target, one converts the live switch value (SW[7:0]). The top level selects which pair of BCD digits to route to the right-side display depending on game state.

---

### `bin_2_seg`

```vhdl
entity bin_2_seg is
    Port (
        bin_in  : in  STD_LOGIC_VECTOR(3 downto 0);  -- BCD digit 0–9
        seg_out : out STD_LOGIC_VECTOR(6 downto 0)   -- segments: a-b-c-d-e-f-g
    );
end bin_2_seg;
```

Common-anode encoding (active-low segments). Any value outside 0–9 maps to `1111111` (all off), which is used as the blank state for unused display slots. The 7-bit output is unpacked in the top level into individual `CA`–`CG` ports.

---

### `clk_en` *(imported)*

```vhdl
entity clk_en is
    port (
        clk    : in  std_logic;   -- 100 MHz
        rst    : in  std_logic;   -- active-high
        ce_1ms : out std_logic    -- single-cycle pulse every 1 ms
    );
end clk_en;
```

Counts 0 to 99 999 then pulses `ce_1ms` for one clock cycle. Used to gate all time-sensitive logic (timer divider in FSM, display slot counter in Multiplexor) without creating additional clock domains.

---

### `counter` *(imported)*

```vhdl
entity counter is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        cnt_out : out std_logic_vector(7 downto 0)
    );
end counter;
```

Increments every clock cycle at 100 MHz. Completes a full 0–255 lap every 2.56 µs — far faster than any human reaction, making the sampled value unpredictable. The top level applies a nibble-swap and lower-nibble inversion before latching, adding distribution across the full range.

---

### `debounce` *(imported)*

```vhdl
entity debounce is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        btn_in    : in  std_logic;
        btn_press : out std_logic   -- single-cycle pulse on stable rising edge
    );
end debounce;
```

Waits for `btn_in` to remain stable for 10 ms before emitting a one-cycle `btn_press` pulse. Prevents bounce on BTNC from triggering multiple FSM transitions.

---

## Signal Flow Summary

```
SW[7:0] ──► bin_2_bcd ──► s_sw_h/t/u ──┐
                                         ├──► Multiplexor (right side, S_RUN)
counter ──► [latch] ──► bin_2_bcd ──────┘    (timer BCD in S_WIN)
               │
               └──► bin_2_bcd ──► s_target_h/t/u ──► Multiplexor (left side, S_WIN)

Multiplexor ──► mux_out ──► bin_2_seg ──► seg[6:0] ──► CA–CG
            └──► an[7:0]
            └──► dp
```

---

*Part of the [Binary Perception Game](../../README.md) — Digital electronics 1 course, 2026.*
