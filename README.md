# PingPong
🏓 VHDL Ping Pong Game for Basys 3 FPGA
This project implements a simple Ping Pong game in VHDL, designed for the Basys 3 FPGA development board.
It uses the board’s push buttons as player controls and generates VGA output to display the game in real time.

🎯 Features
* VGA Display Output — Renders the Ping Pong game on a monitor.
* Four Directional Controls —
* upleft / downleft for Player 1 paddle movement
* upright / downright for Player 2 paddle movement
* Real-Time Game Logic — Paddle collision detection, ball movement, and scoring system.
* RGB Output Control — 4-bit values for each color channel (R, G, B) for richer display.
* Sync Signals — hsync and vsync generation for VGA protocol compliance.

🛠 Requirements:
* Basys 3 FPGA (Xilinx Artix-7)
* VGA Cable & Monitor
* Xilinx Vivado for synthesis and bitstream generation
