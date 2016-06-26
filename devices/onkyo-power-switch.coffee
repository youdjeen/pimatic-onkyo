module.exports = (env) ->

  Promise = env.require 'bluebird'

  # Device class representing the power state of the Onkyo AVR
  class OnkyoPowerSwitch extends env.devices.PowerSwitch

    # Create a new OnkyoPowerSwitch device
    # @param [Object] config    device configuration
    constructor: (@config, @plugin) ->
      env.logger.debug "Initializing OnkyoPowerSwitch..."
      @id = @config.id
      @name = @config.name

      # attributes:
      #   volume:
      #     description: "The master volume"
      #     type: "number"
      #     acronym: 'VOL'
      #   input:
      #     description: "The current input"
      #     type: "string"
      #     acronym: 'INPUT'

      # @_presence = false
      # @_volume = 0
      # @_input = ""
      
      # @requestUpdate()
      
      @plugin.on 'power', (state) =>
        @_setState state

      @plugin.sendCommand "!1PWRQSTN\r"

      super()

    changeStateTo: (state) =>
      if state then @plugin.sendCommand "!1PWR01\r"
      else @plugin.sendCommand "!1PWR00\r"

    # _setVolume: (value) ->
    #   @_volume = value
    #   @emit 'volume', value

    # _setInput: (value) ->
    #   @_input = value
    #   @emit 'input', value

    # requestUpdate: () =>
    #   env.logger.debug "Refreshing status..."
    #   @plugin.sendCommand "!1PWRQSTN\r"

    # getPresence: () =>
    #   return new Promise.resolve @_presence

    # getVolume: () =>
    #   return new Promise.resolve @_volume

    # getInput: () =>
    #   return new Promise.resolve @_input
