module.exports = (env) ->

  Promise = env.require 'bluebird'

  # Device class representing the input buttons of the Onkyo AVR
  class OnkyoInputButtons extends env.devices.Device

    attributes:
      button:
        description: "The last pressed button"
        type: "string"

    actions:
      buttonPressed:
        params:
          buttonId:
            type: "string"
        description: "Press a button"

    template: "buttons"

    constructor: (@config, @plugin)->
      @id = @config.id
      @name = @config.name

      @_lastPressedButton = ""

      super()

    getButton: -> Promise.resolve(@_lastPressedButton)

    buttonPressed: (buttonId) ->
      for b in @config.buttons
        if b.id is buttonId
          @plugin.sendCommand "!1SLI#{b.code}\r"
          @_lastPressedButton = b.id
          @emit 'button', b.id
          return Promise.resolve()
      throw new Error("No button with the id #{buttonId} found")

          
