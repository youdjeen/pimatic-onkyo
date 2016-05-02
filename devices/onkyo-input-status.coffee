module.exports = (env) ->

  Promise = env.require 'bluebird'

  # Device class representing the input status of the Onkyo AVR
  class OnkyoInputStatus extends env.devices.Device

    attributes:
      status:
        description: "The current input"
        type: "string"

    # template: "buttons"

    constructor: (@config, @plugin)->
      @id = config.id
      @name = config.name

      @_status = ""

      @plugin.on 'input', (input) =>
        @_status = @getStatusFromCode input
        @emit 'status', @_status

      @plugin.sendCommand "!1SLIQSTN\r"

      super()

    getStatus: -> Promise.resolve(@_status)

    getStatusFromCode: (code) ->
      switch code
        when '00' then return "VCR"
        when '01' then return "Cable"
        when '02' then return "Game"
        when '23' then return "CD"
        when '24' then return "Tuner"
        else return ""

          
