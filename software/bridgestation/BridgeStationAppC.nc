/*
 * Copyright (c) 2012 Andres Vahter.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 *
 * - Neither the name of the copyright holders nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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
    
    components new PoolC(message_t, RADIO_OUT_QUEUE_SIZE) as RadioOutPoolC;
    App.RadioOutPool -> RadioOutPoolC;
    components new QueueC(message_t*, RADIO_OUT_QUEUE_SIZE) as RadioOutQueueC;
    App.RadioOutQueue -> RadioOutQueueC;

    components new PoolC(message_t, UART_OUT_QUEUE_SIZE) as UartOutPoolC;
    App.UartOutPool -> UartOutPoolC;
    components new QueueC(message_t*, UART_OUT_QUEUE_SIZE) as UartOutQueueC;
    App.UartOutQueue -> UartOutQueueC;
}
