// The plugin has nothing to run at runtime: this service exists so that
// enabling the plugin wires up the PRINT keybind and the menu rows, and
// disabling or removing it takes both back out again.
import QtQuick
import Quickshell

Item {
  id: root

  property var pluginRegistry: null
  property var manifest: null
  readonly property string script: Qt.resolvedUrl("omarchy-pretty-screenshot").toString().replace(/^file:\/\//, "")

  Component.onCompleted: Quickshell.execDetached([script, "--setup"])

  // Only a real disable/remove: the registry is injected after createObject,
  // so a null one means shell teardown, and a shell restart destroys us with
  // the plugin still enabled. The script re-checks shell.json on disk anyway.
  Component.onDestruction: {
    if (root.pluginRegistry && root.manifest
        && root.pluginRegistry.isEnabled(root.manifest.id) === false)
      Quickshell.execDetached([script, "--unsetup"])
  }
}
