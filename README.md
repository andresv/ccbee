# CCBee

CCBee is TI CC430F5137 based radio module that fits into XBee PRO socket.
It has UART and SPI interface for sending and receiving data.

## Hardware

Schematic and PCB are designed using [EAGLE](http://www.cadsoftusa.com/). This is 2 layer design. 50 Ohm lines are calculated for board thickness 1 mm and copper 35 um.
Calculations are done with [AppCAD](http://www.hp.woodshot.com/appcad/version302/setup.exe). Another good tool for calculating lines is [TX-Line](http://web.awrcorp.com/Usa/Products/Optional-Products/TX-Line/).
If your board thickness will be different, calculate new values using AppCAD "Coplanar Waveguide".
This board is designed for 868 MHz ISM frequency band.

## BOM

<table>
    <tr>
        <td><b>Part</b></td> <td><b>Value</b></td> <td><b>Package</b></td> <td><b>Quantity</b></td> <td><b>Farnell code</b></td>
    </tr>
    <tr>
        <td>IC1</td> <td>Balun: Johanson Technology 0896BM15A0001E</td> <td></td> <td>1</td> <td>1885513</td>
    </tr>
    <tr>
        <td>X2</td> <td>Antenna connector</td> <td>U.FL-R-SMT</td> <td>1</td> <td>1688077</td>
    </tr>
    <tr>
        <td>X3</td> <td>Chip antenna: Johanson Technology 0868AT43A0020E</td> <td></td> <td>1</td> <td>1885493</td>
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
    <tr>
        <td>C1, C2</td> <td>12.5 pF</td> <td>0402</td> <td>2</td> <td>1828875</td>
    </tr>
    <tr>
        <td>C3, C6, C8, C10, C11, C12, C13, C15, C17, C19</td> <td>0.1 uF</td> <td>0402</td> <td>10</td> <td>1828860</td>
    </tr>
    <tr>
        <td>C4</td> <td>0.47 uF</td> <td>0603</td> <td>1</td> <td>1833805</td>
    </tr>
    <tr>
        <td>C5, C7, C9, C18</td> <td>10 uF</td> <td>0603</td> <td>4</td> <td>1886093</td>
    </tr>
    <tr>
        <td>C14, C16</td> <td>2 pF</td> <td>0402</td> <td>2</td> <td>1758932</td>
    </tr>
    <tr>
        <td>C20, C21</td> <td>18 pF</td> <td>0402</td> <td>2</td> <td>1828876</td>
    </tr>
    <tr>
        <td>C22, C23</td> <td>1.8 pF</td> <td>0402</td> <td>2</td> <td>1828870</td>
    </tr>
    <tr>
        <td>C25</td> <td>2.2 nF</td> <td>0402</td> <td>1</td> <td>1414582</td>
    </tr>
    <tr>
        <td>L1</td> <td>ferrite 1 kOhm</td> <td>0402</td> <td>1</td> <td>1515788</td>
    </tr>
    <tr>
        <td>L2</td> <td>5.6 nH</td> <td>0402</td> <td>1</td> <td>1669640</td>
    </tr>
    <tr>
        <td>L3</td> <td>12 nH</td> <td>0402</td> <td>1</td> <td>1515341</td>
    </tr>
    <tr>
        <td>L4</td> <td>1.8 nH</td> <td>0402</td> <td>1</td> <td>1669627</td>
    </tr>
    <tr>
        <td>R1</td> <td>56 kOhm</td> <td>0402</td> <td>1</td> <td>1738874</td>
    </tr>
    <tr>
        <td>R2</td> <td>0 Ohm</td> <td>0402</td> <td>1</td> <td>2008330</td>
    </tr>
    <tr>
        <td>R3</td> <td>47 kOhm</td> <td>0402</td> <td>1</td> <td>1840558</td>
    </tr>
    <tr>
        <td>R4</td> <td>330 Ohm</td> <td>0402</td> <td>1</td> <td>1840544</td>
    </tr>
    <tr>
        <td>R5, R6, R7</td> <td>1 kOhm</td> <td>0402</td> <td>3</td> <td>1738850</td>
    </tr>
    <tr>
        <td>LED0, LED1, LED2</td> <td>red</td> <td>0603</td> <td>3</td> <td>1226389</td>
    </tr>
    <tr>
        <td>Pinheader</td> <td></td> <td>2 mm x 10 pins</td> <td>2</td> <td>1668551</td>
    </tr>
</table>

## Software

### TinyOS installation (Ubuntu)

#### Toolchain
For toolchain installation follow instructions from: http://tinyprod.net/debian-dev/

#### Source
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

    source ~/tinyos-prod/tinyos-env.sh ~/tinyos-prod

[Here](https://github.com/tp-freeforall/prod/blob/msp430-int/00b_Development_Environment) you can find more detailed instructions.

Get platform files. Put this repository somewhere you like, for example to home:

    cd ~/
    git clone git://github.com/andresv/ccbee.git

Create symlinks to platform files:

    ln -s ~/ccbee/software/tinyos/ccbee.target ~/tinyos-prod/support/make
    ln -s ~/ccbee/software/tinyos/ccbee ~/tinyos-prod/tos/platforms

Now it is possible to compile TinyOS apps for ccbee. Try it!

    cd ~/tinyos-prod/apps/Blink
    make ccbee

Use MSP-FET430UIF or alternative to download image to the microcontroller. This example shows how to use [mspdebug](http://mspdebug.sourceforge.net/) for doing that.

    mspdebug uif -d /dev/ttyUSB0 "prog build/ccbee/main.ihex"

### Measurements

It seems that RF part is currently quite bad. Probably it is due to 2 layer design and I guess this coplanar waveguide does not work as expected.
With PATABLE0 set to 0xC0 (max) I measured 3 dBm, with 0xC3 2 dBm and with 0xC6 about 1 dBm. Actually with 0xC0 it should be near 10 dBm.
PATABLE0 can be set in Makefile:

    CFLAGS += -DSMARTRF_SETTING_PATABLE0=0xC0

### Firmware

Serial <-> radio bridge firmware is not yet ready.

## LICENSE

[hardware](https://github.com/andresv/ccbee/blob/master/hardware/LICENSE.txt) and [software](https://github.com/andresv/ccbee/blob/master/software/LICENSE.txt)
