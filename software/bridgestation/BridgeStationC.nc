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

    }
}
implementation {
    
    event void Boot.booted() {
        call UartControl.start();
        call RadioControl.start();
    }

    //----------------------------------------------------------------------
    // Peripheral start/stop events
    //----------------------------------------------------------------------
    event void RadioControl.startDone(error_t error) {
        if (error != SUCCESS) {
            call RadioControl.start();
        }
    }
    event void RadioControl.stopDone(error_t error) {}

    //----------------------------------------------------------------------
    // Radio events
    //----------------------------------------------------------------------
    event message_t* RadioReceive.receive(message_t* msg, void* payload, uint8_t len) {

        return msg;
    }

    event void RadioSend.sendDone(message_t* msg, error_t error) {

    }

    //----------------------------------------------------------------------
    // UART events
    //----------------------------------------------------------------------
    async event void UartStream.sendDone(uint8_t* buf, uint16_t len, error_t error) {

    }
    
    async event void UartStream.receivedByte(uint8_t byte) {
        call UartRxTimer.startOneShot(WAIT_UART_PACKET_END_TIME);
    }

    event void UartRxTimer.fired() {
        // send data
    }

    async event void UartStream.receiveDone(uint8_t* buf, uint16_t len, error_t error) {

    }
}
