# AES-128-encryption-implementation-using-verilog

1. Module Declaration and Inputs/Outputs:
The module is named aes128, and it has three inputs: rst, plain_text, and key, each with 128 bits width.
The output is a 128-bit wide register named out that will store the encrypted data. There are also 
some internal registers which  are defined for storing intermediate values and various components of the AES algorithm.

2. Parameter Definition: These are mainly various states of the state machine.

3. Rcon Initialization: There are 10 round constants. Each of them are 32 bits wide. This is necessary for key expansion. 

4. S-Box Initialization: There is a pre-defined substitution box, which is essential for byte substitution.

5. Key Expansion: It involves expanding the initial 128-bit encryption key into a series of 128-bit round keys.
Each 128 bit key is also divided into 4 words, where each word contains 32 bits.
Initialization: The initial 128-bit encryption key is divided into four 32-bit words, labeled W[0], W[1], W[2], and W[3].
Round Key Generation: The round keys are generated iteratively, with each round key being derived from the previous round key. The process involves a combination of word rotations, XOR operations, and the application of a constant value.
Word Rotation: The first word (W[0]) is rotated left by one byte. This means that the first byte of the word becomes the last byte, and the remaining bytes shift left accordingly.
XOR with Rcon: The rotated word is XORed with a round-specific constant value called Rcon. Rcon is a pre-determined value that changes with each round.
XOR with Previous Word: The result of the XOR operation is XORed with the fourth word (W[3]) from the previous round.
Subsequent Words: The remaining three words (W[1], W[2], and W[3]) are simply copied from the previous round.
Iteration: This process is repeated for a total of 11 rounds, generating 12 round keys in total

6. State Machine: There are 5 states. They are IDLE, addRoundKey, subBytes, shiftRows, mixColumns  
  IDLE : It is initial state of the state machine  
  addRoundKey: Mixes the data with the round key to make it more difficult to analyze and decrypt  
  subBytes: For substituting byte from previously defined S-box  
  shiftRows: Cyclically shift each row of the state to the left. The number of positions shifted depends on the row.   
  mixColumns:Perform a matrix multiplication on each column of the state.  

Addroundkey is run once at the beginning and once after each round, so a total of 11 times. Shiftrows and byte substituitions are run for 10 times for 10 rounds. The mix column is ignored in the final round, so it is run 9 times.

note: In the final round, which is round 11 including the initial addRoundKey operation, mixColumns operation is ignored.

7. Testbench: Finally the testbench is used to give stimulation to the top module. 
