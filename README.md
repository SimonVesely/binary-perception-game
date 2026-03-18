# Binary Perception Game (Binární postřehovka)

## Team members

* Adam Uhlíř
* Gabriel Novák
* Jan Ručka
* Simon Veselý

67
67

## Abstract

The Binary Perception Game is a fast-paced educational FPGA project that trains players to quickly convert a random decimal number (1–255) into its 8-bit binary equivalent. The game runs on the Nexys A7 board and uses a free-running background counter to generate the target number. In the idle phase the displays show zeros (or the time of the last successful round) and wait for the user to press the btnu button. Once started, the frozen decimal number appears on the left four 7-segment displays while the player sets the binary value with switches sw0–7. The current input value is shown in real time on the right four 7-segment displays. When the binary combination matches the target, the game automatically returns to the idle phase and displays the elapsed time. LEDs light up to indicate active switches during gameplay. The project demonstrates key digital design concepts including counters, finite state machines, 7-segment decoding, real-time comparison logic, and simple timing measurement.

The main contributions of the project are:

* Fair random number generation using a free-running 8-bit counter
* Real-time binary input validation and decimal display on dual 7-segment sets
* Two-state game FSM with automatic timing and return to idle
* Clear visual feedback via 7-segment displays and LEDs

## Hardware description of demo application

The demo runs on the **Nexys A7-100T** FPGA board and uses only on-board peripherals:

* **sw[7:0]** – 8-bit binary input from the user
* **btnu** – start / restart button
* **8× 7-segment displays** – left four show the target decimal number, right four show the current switch value (decimal)
* **LEDs** – indicate which switches are currently active (1 = on)

**Top-level schematic description**  
The top module (`binary_perception_top.vhd`) instantiates:
- 8-bit free-running counter (random source)
- Game FSM (IDLE ↔ GAME)
- Two 7-segment decoder blocks (decimal output)
- 32-bit timer (for elapsed time)
- Comparator + switch debouncer
- LED driver

## Software description

The core algorithm is a simple two-state finite state machine:

```mermaid
stateDiagram-v2
    [*] --> IDLE
    IDLE --> GAME : btnu pressed
    GAME --> IDLE : correct binary input
