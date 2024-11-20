"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
Object.defineProperty(exports, "CommandBar", {
  enumerable: true,
  get: function () {
    return _TinyMDECommandBar.default;
  }
});
Object.defineProperty(exports, "Editor", {
  enumerable: true,
  get: function () {
    return _TinyMDE.default;
  }
});
var _TinyMDECommandBar = _interopRequireDefault(require("./TinyMDECommandBar"));
var _TinyMDE = _interopRequireDefault(require("./TinyMDE"));
function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }