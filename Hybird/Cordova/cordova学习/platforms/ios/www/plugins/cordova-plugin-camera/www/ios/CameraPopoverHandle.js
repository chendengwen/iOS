cordova.define("cordova-plugin-camera.CameraPopoverHandle", function(require, exports, module) {

    var exec = require('cordova/exec');

    /**
     * @namespace navigator
     */

    /**
     * A handle to an image picker popover.
     *
     * __Supported Platforms__
     *
     * - iOS
     *
     * @example
     * navigator.camera.getPicture(onSuccess, onFail,
     * {
     *     destinationType: Camera.DestinationType.FILE_URI,
     *     sourceType: Camera.PictureSourceType.PHOTOLIBRARY,
     *     popoverOptions: new CameraPopoverOptions(300, 300, 100, 100, Camera.PopoverArrowDirection.ARROW_ANY)
     * });
     *
     * // Reposition the popover if the orientation changes.
     * window.onorientationchange = function() {
     *     var cameraPopoverHandle = new CameraPopoverHandle();
     *     var cameraPopoverOptions = new CameraPopoverOptions(0, 0, 100, 100, Camera.PopoverArrowDirection.ARROW_ANY);
     *     cameraPopoverHandle.setPosition(cameraPopoverOptions);
     * }
     * @module CameraPopoverHandle
     */
    var CameraPopoverHandle = function () {
        /**
         * Can be used to reposition the image selection dialog,
         * for example, when the device orientation changes.
         * @memberof CameraPopoverHandle
         * @instance
         * @method setPosition
         * @param {module:CameraPopoverOptions} popoverOptions
         */
        this.setPosition = function (popoverOptions) {
            var args = [ popoverOptions ];
            exec(null, null, 'Camera', 'repositionPopover', args);
        };
    };

    module.exports = CameraPopoverHandle;

});
