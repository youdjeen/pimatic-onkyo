module.exports = (env) ->

  Promise = env.require 'bluebird'

  # Device class representing the power state of the Onkyo AVR
  class OnkyoMuteSwitch extends env.devices.PowerSwitch

    # Create a new OnkyoAvrPresenceSensor device
    # @param [Object] config    device configuration
    constructor: (@config, @plugin) ->
      env.logger.debug "Initializing OnkyoMuteSwitch..."
      @id = config.id
      @name = config.name

      @plugin.on 'mute', (state) =>
        @_setState state

      @plugin.sendCommand "!1AMTQSTN\r"

      super()

    changeStateTo: (state) =>
      if state then @plugin.sendCommand "!1AMT01\r"
      else @plugin.sendCommand "!1AMT00\r"

