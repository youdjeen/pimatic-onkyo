module.exports = (env) ->
  Promise = env.require 'bluebird'
  assert = env.require 'cassert'
  serialport = require('serialport')
  SerialPort = serialport.SerialPort

  devices = [
    'onkyo-power-switch'
    'onkyo-mute-switch'
    'onkyo-volume'
    'onkyo-input-buttons'
    'onkyo-input-status'
  ]

  class Onkyo extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      env.logger.info("Initializing the OnkyoAvrSerial plugin...")

      @initializeSerialPort()

      # register devices
      deviceConfigDef = require("./device-config-schema")
      for device in devices
        # convert kebap-case to camel-case notation with first character capitalized
        className = device.replace /(^[a-z])|(\-[a-z])/g, ($1) -> $1.toUpperCase().replace('-','')
        classType = require('./devices/' + device)(env)
        env.logger.debug "Registering device class #{className}"
        @framework.deviceManager.registerDeviceClass(className, {
          configDef: deviceConfigDef[className],
          createCallback: @callbackHandler(className, classType)
        })

    initializeSerialPort: ->
      @serialPort = new SerialPort @config.serialPort, { baudRate: @config.baudRate, parser: serialport.parsers.readline("\x1A") }
      @serialPort.on 'open', () =>
        env.logger.info "Serial port is open."
        @serialPort.on 'data', (data) =>
          env.logger.debug "Serial port data received: #{data}"
          @parseSerialData data

    parseSerialData: (data) =>
      data = data.replace "!1", ""
      command = data.substr(0, 3)
      parameter = data.substr(3, 2)
      env.logger.debug "Command is #{command} and parameter is #{parameter}"
      switch command
          when 'PWR' then (
            @emit 'power', if parameter is '01' then true else false
          )
          when 'AMT' then (
            @emit 'mute', if parameter is '01' then true else false
          )
          when 'SLI' then (
            @emit 'input', parameter
          )
          when 'MVL' then (
            @emit 'volume', parseInt(parameter, 16)
          )

    sendCommand: (command) =>
      env.logger.debug "Sending command #{command}"
      @serialPort.write command, () =>
        @serialPort.drain () =>
          env.logger.debug "Command #{command} sent successfully."

    callbackHandler: (className, classType) ->
      # this closure is required to keep the className and classType context as part of the iteration
      return (config, lastState) =>
        return new classType(config, @)

  # ###Finally
  # Create a instance of my plugin
  myPlugin = new Onkyo
  # and return it to the framework.
  return myPlugin