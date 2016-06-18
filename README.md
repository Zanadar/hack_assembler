Hack Assembler
=========

This is an implementation of the hack assembler from `Nand2Tetris`, a guided tour through the guts of how a computer works. This particular program is designed to take valid hack assembly code and turn it into binary for the hack CPU to run. The assembly language is super basic, but you can write simple programs that take IO. The tests even include pong!

##How it works

Basically it runs through your assembly code file in two passes and spits out a `.hack` file. This `hack` file is a "binary" (its just a text file of zeros and ones) that you can run on the hack CPU emulator supplied by the designers of `nand2tetris`.  
In terms of implementation, there's a `Hacker` class which coordinates the runs through the assembly and writes the appropriate binary code from symbols, a `Parser` that does the actual work of parsing instruction types and turning them into symbols, and a `SymbolTable` where we keep track assignment for jumps and look up built in symbols.

##Install

    $ git clone git://github.com/zanadar/hack_assembler.git
    $ cd hack_assembler
    $ .bin/hacksemble path/to-assembly-file.asm
    ...
    $ Your goods are delivered!

##Status
I'd love to add some tests (wouldn't we all!) The `Parser` in particular, has some gnarly regex magic, which is fairly fiddly. I could also envision some refactoring the `Hacker` class to make it cleaner, and maybe spilt up the responsibilily of generating the actual binary code to another class.
