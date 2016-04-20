# #my-plugin configuration options
# Declare your config option for your plugin here. 
module.exports = {
  title: "Onkyo AVR Serial configuration options"
  type: "object"
  properties:
    serialPort:
      description: "The serial port to use for communicating with the Onkyo receiver"
      type: "string"
      default: "/dev/ttyUSB0"
    baudRate:
      description: "The serial port baud rate used when communicating with the Onkyo receiver"
      type: "int"
      default: "9600"
}