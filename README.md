# bcal
calc for bit operation

support positive integer only

# Usage

## Start bcal

```bash
$ bcal
```

## Functions

### the four basic arithmetic operators

```bash
calc   >> 1+2
result >> 3
```

```bash
calc   >> 1+2*3
result >> 7
```

```bash
calc   >> (1+2)*3
result >> 9
```

```bash
calc   >> (9+8)/7
result >> 2
```

### radix conversion

```bash
calc   >> 10.hex
hex    >> 10    ->      0xa
result >> 1
```

```bash
calc   >> (1+2+4).bin
bin    >> 7     ->      0b111
result >> 7
```

```bash
calc   >> (3.bin*8.bin).hex
bin    >> 3     ->      0b11
bin    >> 8     ->      0b1000
hex    >> 24    ->      0x18
result >> 24
```
### bit operation

#### AND

```bash
calc   >> (0b10101010 & 0xf0).bin
bin    >> 160   ->      0b10100000
result >> 160
```

#### OR

```bash
calc   >> (224.bin | 26.bin).bin
bin    >> 224   ->      0b11100000
bin    >> 26    ->      0b11010
bin    >> 250   ->      0b11111010
result >> 250
```

#### XOR

```bash
calc   >> (224.bin ^ 126.bin).bin
bin    >> 224   ->      0b11100000
bin    >> 126   ->      0b1111110
bin    >> 158   ->      0b10011110
result >> 158
```

#### NOT

```bash
calc   >> ~0xc
result >> 3
```

without bit width specification
```bash
calc   >> (~0x3.bin).bin
bin    >> 3     ->      0b11
bin    >> 0     ->      0b0
result >> 0
```

with bit width specification
```bash
calc   >> (0x3.bin.inv(4)).bin
bin    >> 3     ->      0b11
bin    >> 12    ->      0b1100
result >> 12
```
#### SHIFT

right shift
```bash
calc   >> (0xa << 4).hex
hex    >> 160   ->      0xa0
result >> 160
```

left shift
```bash
calc   >> (0xf0 >> 2).bin
bin    >> 60    ->      0b111100
result >> 60
```
#### Take bit

single bit
```bash
calc   >> 0b1010[0]
result >> 0
calc   >> 0b1010[1]
result >> 1
```

multi bits
```bash
calc   >> 0b1010[1,0].bin
bin    >> 2     ->      0b10
result >> 2
calc   >> 0b1010[3,1].bin
bin    >> 5     ->      0b101
result >> 5
```

### OTHERS

#### reuse previous result

previous result is saved to `@`
```bash
calc   >> 1+3
result >> 4
calc   >> @*2
result >> 8
calc   >> @.bin
bin    >> 8     ->      0b1000
result >> 8
calc   >> (@.inv(4)).hex
hex    >> 7     ->      0x7
result >> 7
```

