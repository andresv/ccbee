# CCBee

CCBee is TI CC430F5137 based radio module that fits into XBee PRO socket.
It has UART and SPI interface for sending and receiving data.

## Hardware

Schematic and PCB is designed using [EAGLE](http://www.cadsoftusa.com/).

## BOM

<table>
    <tr>
        <td><b>Part</b></td> <td><b>Value</b></td> <td><b>Package</b></td> <td><b>Quantity</b></td> <td><b>Farnell code</b></td>
    </tr>
    <tr>
        <td>IC1</td> <td>Johanson Technology 0896BM15A0001E</td> <td></td> <td>1</td> <td>1885513</td>
    </tr>
    <tr>
        <td>X2</td> <td></td> <td>U.FL-R-SMT</td> <td>1</td> <td>1688077</td>
    </tr>
    <tr>
        <td>X3</td> <td>Johanson Technology 0868AT43A0020E</td> <td></td> <td>1</td> <td>1885493</td>
    </tr>
    <tr>
        <td>U1</td> <td>Texas Instruments CC430F5137</td> <td>48VQFN</td> <td>1</td> <td>1903415</td>
    </tr>
    <tr>
        <td>Q1</td> <td>32 kHz</td> <td>3.2 mm x 1.5 mm</td> <td>1</td> <td>1712821</td>
    </tr>
    <tr>
        <td>Q2</td> <td>26 MHz</td> <td>5.0 mm x 3.2 mm</td> <td>1</td> <td>1841997</td>
    </tr>
</table>

## Software

### Install TinyOS

For toolchain installation follow instructions from: http://tinyprod.net/repos/debian-dev/
    
Install TinyOS source:

    cd ~/
    git clone git://github.com/tp-freeforall/prod.git tinyos-prod

Setup environment variables. Create file called **~/tinyos-prod/tinyos-env.sh**

```shell
# Here we setup the environment
# variables needed by the TinyOS 
# make system

if [ $# -eq 0 ]
then
    echo "ERROR: TinyOS path not specified as first argument!"
    exit 1
else
    ROOT_DIR=$1

    echo "Setting up for: $ROOT_DIR"
    export TOSROOT=
    export TOSDIR=
    export MAKERULES=

    TOSROOT=$ROOT_DIR
    TOSDIR="$TOSROOT/tos"
    CLASSPATH=$TOSROOT/support/sdk/java/:$TOSROOT/support/sdk/java/tinyos.jar:.:$CLASSPATH
    MAKERULES="$TOSROOT/support/make/Makerules"

    export TOSROOT
    export TOSDIR
    export CLASSPATH
    export MAKERULES
fi
```

Now add this to your **~/.bashrc** file:

    source ~/tinyos-prod/tinyos-env.sh ~/tinyos-prod/

[Here](https://github.com/tp-freeforall/prod/blob/msp430-int/00b_Development_Environment) you can find more detailed instructions.

Get platform files. Put this repository somewhere you like, for example to home:
    
    cd ~/
    git clone git://github.com/andresv/ccbee.git

Create symlinks to platform files:

    ln -s ~/ccbee/software/tinyos/bee.target ~/tinyos-prod/support/make/bee.target
    ln -s ~/ccbee/software/tinyos/bee ~/tinyos-prod/platforms/bee

Now it is possible to compile TinyOS apps for ccbee. Try it!

    cd ~/tinyos-prod/apps/Blink
    make bee

### Firmfare

Firmware is not yet ready!

## LICENSE

[hardware](https://github.com/andresv/ccbee/blob/master/hardware/LICENSE.txt) and [software](https://github.com/andresv/ccbee/blob/master/software/LICENSE.txt) 
