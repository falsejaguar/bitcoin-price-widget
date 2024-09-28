import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid 2.0

Item {
    id: main

    Layout.minimumWidth: vertical ? 0 : 200
    Layout.maximumWidth: vertical ? Infinity : Layout.minimumWidth
    Layout.preferredWidth: vertical ? undefined : Layout.minimumWidth

    Layout.minimumHeight: vertical ? 100 : 0
    Layout.maximumHeight: vertical ? Layout.minimumHeight : Infinity
    Layout.preferredHeight: vertical ? Layout.minimumHeight : PlasmaCore.Theme.mSize(PlasmaCore.Theme.defaultFont).height * 2

    readonly property bool vertical: plasmoid.formFactor == PlasmaCore.Types.Vertical

    width: 200
    height: 100

    Label {
        id: btcPriceLabel
        anchors.centerIn: parent
        text: "Loading..."
        color: "#00FF00"
    }

    Timer {
        interval: 60000 // 1 minute
        running: true
        repeat: true
        onTriggered: updateBTCPrice()
    }

    function updateBTCPrice() {
        console.log("Fetching BTC price...")
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log("XHR status: " + xhr.status);
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText);
                        console.log("API response: " + xhr.responseText);
                        btcPriceLabel.text = "BTC: $" + response.bitcoin.usd;
                    } catch (e) {
                        console.log("Error parsing JSON: " + e);
                        btcPriceLabel.text = "Error parsing price";
                    }
                } else {
                    console.log("Error fetching price: " + xhr.statusText);
                    btcPriceLabel.text = "Error fetching price";
                }
            }
        }
        xhr.send();
    }

    Component.onCompleted: updateBTCPrice()
}
