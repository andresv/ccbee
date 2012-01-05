# CCBee

CCBee is TI CC430F5137 based radio module that fits into XBee PRO socket.
It has UART and SPI interface for sending and receiving data.

## Software

### Install TinyOS

Typically TinyOS is installed to /opt

    cd /opt
    git clone git://github.com/tp-freeforall/prod.git
    sudo chown -R youruser:youruser /opt/prod

Setup environmental variables. Create file called **/opt/tinyos-env.sh**

```shell
# Here we setup the environment
# variables needed by the tinyos 
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

    source /opt/tinyos-env.sh /opt/prod

Get platform files. Put this repository somewhere you like, for example to home:
    
    cd /home/yourname
    git clone git://github.com/andresv/ccbee.git

Create symlinks to platform files:

    ln -s /home/yourname/ccbee/software/tinyos/bee.target /opt/prod/support/make/bee.target
    ln -s /home/yourname/ccbee/software/tinyos/bee /opt/prod/platforms/bee

Now it is possible to compile TinyOS apps for ccbee. Try it!

    cd /opt/prod/apps/Blink
    make bee

### Firmfare

Currently firmware is not yet ready!

## LICENSE

[hardware](https://github.com/andresv/ccbee/blob/master/hardware/LICENSE.txt) and [software](https://github.com/andresv/ccbee/blob/master/software/LICENSE.txt) 
