module.exports = {
  title: "pimatic-onkyo device config schemas"
  OnkyoVolume: {
    title: "Onkyo Volume"
    description: "Onkyo Volume"
    type: "object"
    extensions: ["xLink", "xPresentLabel", "xAbsentLabel"]
    properties: []
  },
  OnkyoPowerSwitch: {
    title: "Onkyo Power Switch"
    description: "Onkyo Power Switch"
    type: "object"
    extensions: ["xLink", "xOnLabel", "xOffLabel"]
    properties: []
  },
  OnkyoMuteSwitch: {
    title: "Onkyo Mute Switch"
    description: "Onkyo Mute Switch"
    type: "object"
    extensions: ["xLink", "xOnLabel", "xOffLabel"]
    properties: []
  },
  OnkyoInputStatus: {
    title: "Onkyo Input Status"
    description: "Onkyo Input Status"
    type: "object"
    extensions: ["xLink"]
    properties: []
  },
  OnkyoInputButtons: {
    title: "Onkyo Input Buttons"
    type: "object"
    extensions: ["xLink"]
    properties:
      buttons:
        description: "Buttons to display"
        type: "array"
        default: []
        format: "table"
        items:
          type: "object"
          properties:
            id:
              type: "string"
            text:
              type: "string"
            code:
              description: "The code of the input button"
              type: "string"
  }
}