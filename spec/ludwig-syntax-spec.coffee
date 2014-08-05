{WorkspaceView} = require 'atom'
LudwigSyntax = require '../lib/ludwig-syntax'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "LudwigSyntax", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('ludwig-syntax')

  describe "when the ludwig-syntax:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.ludwig-syntax')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'ludwig-syntax:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.ludwig-syntax')).toExist()
        atom.workspaceView.trigger 'ludwig-syntax:toggle'
        expect(atom.workspaceView.find('.ludwig-syntax')).not.toExist()
