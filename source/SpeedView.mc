using Toybox.WatchUi;

class SpeedView extends WatchUi.DataField {

    hidden const CENTER = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
    hidden const RIGHT_BOTTOM = Graphics.TEXT_JUSTIFY_RIGHT;
    hidden const LEFT_BOTTOM = Graphics.TEXT_JUSTIFY_LEFT;

    hidden var currentSpeed = 0;
    hidden var averageSpeed = 0;
    hidden var maxSpeed = 0;

    hidden var x = 0;
    hidden var width = 200; // it is recalculated in onLayout
    hidden var width2 = width / 2; // it is recalculated in onLayout
    hidden var y = 0;
    hidden var height = 50; // it is recalculated in onLayout
    hidden var isWide = false; // when the data field is wider than 150 pixels than the layout will be different
    hidden var isTall = false; // when the data field is taller than 150 pixels -"-

    hidden var hasBackgroundColorOption = false;
    hidden var backgroundColor = Graphics.COLOR_WHITE;
    hidden var textColor = Graphics.COLOR_BLACK;
    hidden var unitColor = 0x444444;

    function initialize() {
        DataField.initialize();

        hasBackgroundColorOption = (self has :getBackgroundColor);
        System.println("has background color = " + hasBackgroundColorOption);
    }

    function onLayout(dc) {
        calculateSize(dc);
        //System.println("size is [" + width + "," + height + "] wide = " + isWide);

        onUpdate(dc);
    }

    // See Activity.Info in the documentation for available information.
    // It will be called once a second
    function compute(info) {
        if (info has :currentSpeed && info.currentSpeed != null) {
            currentSpeed = info.currentSpeed;
        }
        if (info has :averageSpeed && info.averageSpeed != null) {
            averageSpeed = info.averageSpeed;
        }
        if (info has :maxSpeed && info.maxSpeed != null) {
            maxSpeed = info.maxSpeed;
        }        
    }


    // Display the value you computed here. This will be called once a second when the data field is visible.
    // Resolution, WxH	200 x 265 pixels for both 520, 820 and 830
    function onUpdate(dc) {
        setupColors();

        // clear background
        dc.setColor(textColor, backgroundColor);
        dc.clear();

        // current heart rate, green if below average, orange if is above average
        var text = textOfDecimal(currentSpeed);
        var font = Graphics.FONT_NUMBER_MILD;
        var textSize = dc.getTextDimensions(text, font);
        dc.drawText(width2, 0, font, text, CENTER);

        // if (curHr > avgHr + tolerance && curHr > 0) {
        //     dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        // } else if (curHr < avgHr - tolerance && curHr > 0) {
        //     dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
        // } else {
        //     dc.setColor(textColor, backgroundColor);
        // }

        // average heart rate
        // text = textOf(avgHr);
        // font = Graphics.FONT_SMALL;
        // dc.setColor(textColor, backgroundColor);
        // dc.drawText(splitRight + 2, y + height - curHrSize[1] + 4, font, text, LEFT_BOTTOM);

        // draw the unit
        // var zoneWidth = 0;
        // text = "bpm";
        // font = Graphics.FONT_SYSTEM_XTINY;
        // var unitSize = dc.getTextDimensions(text, font);
        // dc.setColor(unitColor, Graphics.COLOR_TRANSPARENT);
        // dc.drawText(splitRight + 4, y + height - unitSize[1] - 2, font, text, LEFT_BOTTOM);
    }

    function textOf(n) {
        return n > 0 ? n.format("%d") : "--";
    }

    function textOfDecimal(n) {
        return n > 0 ? n.format("%.1f") : "--";
    }

    function setupColors() {
        if (hasBackgroundColorOption) {
            backgroundColor = getBackgroundColor();
            if (backgroundColor == Graphics.COLOR_BLACK) {
                // night
                textColor = Graphics.COLOR_WHITE;
                unitColor = Graphics.COLOR_LT_GRAY;
            } else {
                // daylight
                textColor = Graphics.COLOR_BLACK;
                unitColor = 0x444444;
            }
        }
    }

    function calculateSize(dc) {
        x = 0;
        width = dc.getWidth();
        y = 0;
        height = dc.getHeight();

        width2 = width / 2;
        isWide = width > 150;
        isTall = height > 150;
    }

}