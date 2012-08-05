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

module BridgeStationC {
    uses {
        interface Leds;
        interface Boot;
        
        interface Timer<TMilli> as UartRxTimer;

        interface SplitControl as RadioControl;
        interface Receive as RadioReceive;
        interface AMSend as RadioSend;
        interface Packet as RadioPacket;

        interface StdControl as UartControl;
        interface UartStream;

        interface Pool<message_t> as RadioOutPool;
        interface Queue<message_t*> as RadioOutQueue;
        interface Pool<message_t> as UartOutPool;
        interface Queue<message_t*> as UartOutQueue;

    }
}
implementation {
    
    message_t* UartRxMessage = NULL;
    message_t* UartTxMessage = NULL;

    uint8_t bytes_received = 0;
    uint8_t rx_byte;

    bool radio_busy = FALSE;
    bool uart_busy = FALSE;

    task void ByteReceivedTask();
    task void SendToRadioTask();
    task void SendToUartTask();

    event void Boot.booted() {
        UartRxMessage = call RadioOutPool.get();

        call UartControl.start();
        call RadioControl.start();
    }

    //----------------------------------------------------------------------
    // Peripheral start/stop events
    //----------------------------------------------------------------------
    event void RadioControl.startDone(error_t error) {
        if (error == SUCCESS) {
            call UartStream.enableReceiveInterrupt();
        }
        else {
            call RadioControl.start();
        }
    }
    event void RadioControl.stopDone(error_t error) {}

    //----------------------------------------------------------------------
    // Radio handling
    //----------------------------------------------------------------------
    event message_t* RadioReceive.receive(message_t* msg, void* payload, uint8_t len) {
        call Leds.led1Toggle();
        
        if (!call UartOutPool.empty() && call UartOutQueue.size() < call UartOutQueue.maxSize()) {
            message_t* tmp = call UartOutPool.get();

            call UartOutQueue.enqueue(msg);
            post SendToUartTask();
            return tmp;
        }
        return msg;
    }

    void SendToRadio() {
        if (!call RadioOutPool.empty() && call RadioOutQueue.size() < call RadioOutQueue.maxSize()) {
            call RadioOutQueue.enqueue(UartRxMessage);

            UartRxMessage = call RadioOutPool.get();
        }

        post SendToRadioTask();
    }

    task void SendToRadioTask() {
        if (!call RadioOutQueue.empty() && !radio_busy) {
            message_t* msg = call RadioOutQueue.dequeue();
            uint8_t len  = call RadioPacket.payloadLength(msg);

            if (call RadioSend.send(0xFFFF, msg, len) == SUCCESS) {
                radio_busy = TRUE;
                call Leds.led2Toggle();
            }
            else {
                call RadioOutPool.put(msg);
                post SendToRadioTask();
            }
        }
    }

    event void RadioSend.sendDone(message_t* msg, error_t error) {
        call RadioOutPool.put(msg);
        radio_busy = FALSE;
        post SendToRadioTask();
    }

    //----------------------------------------------------------------------
    // UART handling
    //----------------------------------------------------------------------
    task void SendToUartTask() {
        if (!call UartOutQueue.empty() && !uart_busy) {
            uint8_t len;
            UartTxMessage = call UartOutQueue.dequeue();
            len = call RadioPacket.payloadLength(UartTxMessage);

            if (call UartStream.send((uint8_t*)UartTxMessage->data, len) == SUCCESS) {
                uart_busy = TRUE;
            }
            else {
                call UartOutPool.put(UartTxMessage);
                post SendToUartTask();
            }
        }
    }

    async event void UartStream.sendDone(uint8_t* buf, uint16_t len, error_t error) {
        call UartOutPool.put(UartTxMessage);
        uart_busy = FALSE;
        post SendToUartTask();
    }
    
    async event void UartStream.receivedByte(uint8_t byte) {
        rx_byte = byte;
        post ByteReceivedTask();
    }

    task void ByteReceivedTask() {
        uint8_t* payload_p = (uint8_t*)call RadioPacket.getPayload(UartRxMessage, TOSH_DATA_LENGTH);

        // fill in message_t payload with bytes received from Uart
        payload_p[bytes_received] = rx_byte;
        bytes_received++;
        call RadioPacket.setPayloadLength(UartRxMessage, bytes_received);

        if (bytes_received < TOSH_DATA_LENGTH) {
            // wait a little, there might be more data coming from Uart
            call UartRxTimer.startOneShot(WAIT_UART_PACKET_END_TIME);
        }
        else {
            // payload is full, try to send data to radio
            bytes_received = 0;
            SendToRadio();
        }
    }

    event void UartRxTimer.fired() {
        bytes_received = 0;
        SendToRadio();
    }

    async event void UartStream.receiveDone(uint8_t* buf, uint16_t len, error_t error) {

    }
}
