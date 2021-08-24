cordova.define("cordova-plugin-camera.Camera", function(require, exports, module) {

    /**
     * @module Camera
     */
    module.exports = {
        /**
         * @description
         * Defines the output format of `Camera.getPicture` call.
         * _Note:_ On iOS passing `DestinationType.NATIVE_URI` along with
         * `PictureSourceType.PHOTOLIBRARY` or `PictureSourceType.SAVEDPHOTOALBUM` will
         * disable any image modifications (resize, quality change, cropping, etc.) due
         * to implementation specific.
         *
         * @enum {number}
         */
        DestinationType: {
            /** Return base64 encoded string. DATA_URL can be very memory intensive and cause app crashes or out of memory errors. Use FILE_URI or NATIVE_URI if possible */
            DATA_URL: 0,
            /** Return file uri (content://media/external/images/media/2 for Android) */
            FILE_URI: 1,
            /** Return native uri (eg. asset-library://... for iOS) */
            NATIVE_URI: 2
        },
        /**
         * @enum {number}
         */
        EncodingType: {
            /** Return JPEG encoded image */
            JPEG: 0,
            /** Return PNG encoded image */
            PNG: 1
        },
        /**
         * @enum {number}
         */
        MediaType: {
            /** Allow selection of still pictures only. DEFAULT. Will return format specified via DestinationType */
            PICTURE: 0,
            /** Allow selection of video only, ONLY RETURNS URL */
            VIDEO: 1,
            /** Allow selection from all media types */
            ALLMEDIA: 2
        },
        /**
         * @description
         * Defines the output format of `Camera.getPicture` call.
         * _Note:_ On iOS passing `PictureSourceType.PHOTOLIBRARY` or `PictureSourceType.SAVEDPHOTOALBUM`
         * along with `DestinationType.NATIVE_URI` will disable any image modifications (resize, quality
         * change, cropping, etc.) due to implementation specific.
         *
         * @enum {number}
         */
        PictureSourceType: {
            /** Choose image from the device's photo library (same as SAVEDPHOTOALBUM for Android) */
            PHOTOLIBRARY: 0,
            /** Take picture from camera */
            CAMERA: 1,
            /** Choose image only from the device's Camera Roll album (same as PHOTOLIBRARY for Android) */
            SAVEDPHOTOALBUM: 2
        },
        /**
         * Matches iOS UIPopoverArrowDirection constants to specify arrow location on popover.
         * @enum {number}
         */
        PopoverArrowDirection: {
            ARROW_UP: 1,
            ARROW_DOWN: 2,
            ARROW_LEFT: 4,
            ARROW_RIGHT: 8,
            ARROW_ANY: 15
        },
        /**
         * @enum {number}
         */
        Direction: {
            /** Use the back-facing camera */
            BACK: 0,
            /** Use the front-facing camera */
            FRONT: 1
        }
    };

});
