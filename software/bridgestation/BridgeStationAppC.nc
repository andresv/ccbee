#include "BridgeStation.h"

configuration BridgeStationAppC {}

implementation {
    components BridgeStationC as App, LedsC, MainC;
    App.Leds -> LedsC;
    App.Boot -> MainC.Boot;
    
    components new AMSenderC(AM_TRANSPORT);
    components new AMReceiverC(AM_TRANSPORT);
    components ActiveMessageC;
    App.RadioReceive -> AMReceiverC;
    App.RadioSend -> AMSenderC;
    App.RadioControl -> ActiveMessageC;
    App.RadioPacket -> AMSenderC;

    components PlatformSerialC;
    App.UartControl -> PlatformSerialC;
    App.UartStream -> PlatformSerialC;

    components new TimerMilliC() as UartRxTimer;
    App.UartRxTimer -> UartRxTimer;
    
    //components new PoolC(message_t, RADIO_OUT_POOL_SIZE) as RadioOutPoolC;
    //App.RadioOutPool -> RadioOutPoolC;
    //components new QueueC(message_t*, RADIO_OUT_POOL_SIZE) as RadioOutQueueC;
    //App.RadioOutQueue -> RadioOutQueueC;
}