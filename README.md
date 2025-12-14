# PIC18 LED Game

A simple **LED reaction game** implemented in **Assembly** for the **PIC18F4550 microcontroller**.  
The game features LEDs moving left and right, and the player must press a button at the correct time to “catch” the light. Wrong presses reduce lives, and the game ends when all lives are lost.

## Features

- LED shifting left and right across PORTB/PORTD.
- Button input detection to “catch” the LED.
- Lives system with 3–4 attempts.
- Game over pattern flashing on LEDs.
- Fully written in PIC18 Assembly language.
- Uses software delays for LED timing and button debounce.

## Hardware Requirements

- PIC18F4550 microcontroller
- LEDs connected to PORTB and PORTD
- Push button connected to RA5 (PORTA pin 5)
- External high-speed oscillator

## How It Works

1. Initialize LEDs and configure PORT pins.
2. Rotate the active LED left and right across the array.
3. Monitor button presses:
   - Correct timing → continue game.
   - Wrong timing → decrement lives.
4. When lives reach 0, display a game over LED pattern.

## Code Structure

- `MAIN_LOOP` → Main game loop controlling LED movement.
- `SHIFTING_LEFT` / `SHIFTING_RIGHT` → Subroutines to move LEDs.
- `TEST` → Checks button input and calls `SOULS` if incorrect.
- `DISPLAY` → Updates LED states.
- `DELAY` / `DELAY2` → Software delays for timing.

## Usage

1. Open the project in MPLAB X IDE.
2. Assemble and upload to a PIC18F4550.
3. Connect LEDs and button as specified.
4. Run and enjoy the LED reaction game!

## License

MIT License
