module.exports = (env) ->

  Promise = env.require 'bluebird'

  # Device class representing the power state of the Onkyo AVR
  class OnkyoVolume extends env.devices.DimmerActuator

    # Create a new OnkyoVolume device
    # @param [Object] config    device configuration
    constructor: (@config, @plugin) ->
      env.logger.debug "Initializing OnkyoVolume..."
      @id = @config.id
      @name = @config.name

      @plugin.on 'volume', (volume) =>
        @_setDimlevel volume

      @plugin.sendCommand "!1MVLQSTN\r"

      super()

    changeDimlevelTo: (volume) =>
      if volume >= 100 then volume = 99
      env.logger.debug "setting volume to #{volume}"
      hexVolume = volume.toString(16).toUpperCase()
      @plugin.sendCommand "!1MVL#{hexVolume}\r"
