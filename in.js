function getAadhaar() {  //Intialisation function for getting Aadhaar information
    if (validated == 1) {


        let deviceInfo = ""
        let device = ""
        let port = 11100
        let portfetch = ""
        do {  // It will search for devices and services for device sdk ,Fetch on Different Ports from 11100 to 11120
            if (
                (getJSON_rdser(port, function (pidoptions, RDService, portfetch) { //Get device and Pid options from devic

                    // Pid options will provide device information for authentication purposes the device info,port ,dev capability
                    if (null != pidoptions && 0 != pidoptions) {
                        alert("Something went wrong: " + pidoptions); // if something went wrong in case of error
                    }
                    else if ("" != String(RDService) && !String(RDService).includes("NOTREADY") && String(RDService).includes("READY")) {

                        let RD = new DOMParser().parseFromString(String(RDService), "text/xml");

                        for (let i = 0; i < RD.length; i++) {
                            let service = RD[i].getAttribute("id");
                            service == "CAPTURE" ? device = RD[i].getAttribute("path") : service == "DEVICEINFO" && (deviceInfo = RD[i].getAttribute("path"));
                        }

                        window.localStorage.setItem('temp', "port=" + portfetch + ",devinfo=" + deviceInfo + ",devcap=" + device)


                        getJSON_info(
                            "http://127.0.0.1:" + portfetch + deviceInfo, // fetching the device 
                            function (i) {
                                null != i
                                    ? alert(
                                        "Something went wrong: " + i + "An error has occurred"
                                    )
                                    : getPidData();
                            }
                        );
                    }
                }),
                    "" != deviceInfo)
            ) {
                window.localStorage.setItem('temp', "port=" + portfetch + ",devinfo=" + deviceInfo + ",devcap=" + device)
                break;
            }
            port += 1;
        } while (port < 11120);
    }
}

function getPidData() {
    let V = window.localStorage.getItem('temp').split(",");
    console.log("v" + V)
    getJSONCapture(
        "http://127.0.0.1:" + V[0].split("=")[1] + V[2].split("=")[1],
        "Test",
        "",
        function (deviceInfo, pidData) {
            if (null == deviceInfo) {
                console.log("PID DATA" + pidData)
                var benc64 = base64(pidData)
                console.log("Base64enc DATA" + benc64)
                return benc64
            }
            alert("Something went wrong: " + deviceInfo);
        }
    );
}
let getJSON_rdser = function (url, V) {
    let device
    let deviceInfo = "http://127.0.0.1:" + url;
    var count = 0
    device = window.navigator.userAgent.indexOf("MSIE") > 0 || window.navigator.userAgent.match(/Trident.*rv\:11\./) ? new window.ActiveXObject("Microsoft.XMLHTTP") : new XMLHttpRequest()

    device.open("RDSERVICE", deviceInfo, 1)

    device.onreadystatechange = () => {
        if (1 == device.readyState && 0 == count || 4 == device.readyState &&
            (200 == device.status
                ? V(null, device.responseText, url)
                : V(device.status, "", url))) {
        }
    }

    device.send();
};

let getJSON_info = function (url, V) {
    let deviceInfo
    var count = 0
    deviceInfo = window.navigator.userAgent.indexOf("MSIE ") > 0 || window.navigator.userAgent.match(/Trident.*rv\:11\./) ? new window.ActiveXObject("Microsoft.XMLHTTP") : new XMLHttpRequest()
    deviceInfo.open("DEVICEINFO", url, 1)

    deviceInfo.onreadystatechange = () => {
        if (1 == deviceInfo.readyState && 0 == count || 4 == deviceInfo.readyState &&
            (200 == deviceInfo.status
                ? V(null, deviceInfo.responseText)
                : V(deviceInfo.response, ""))) {
        }
    }
    deviceInfo.send();
};

let getJSONCapture = function (url, V, wadh, device) {

    let httprequest = new XMLHttpRequest();

    httprequest.open("CAPTURE", url, 1)

    httprequest.responseType = "document"

    let fingerCount = 'fCount="1" fType="2"';
    wadh = "E0jzJ/P8UopUHAieZn8CKqS4WPMi5ZSYXgfnlfkWjrc=";

    let pidoptions = '<PidOptions  ver="1.0"> <Opts ' + fingerCount + ' pCount="0" format="0" pidVer="2.0" wadh=\'' + wadh + '\' timeout="20000"  posh="UNKNOWN" env="P" /> </PidOptions>';

    httprequest = window.navigator.userAgent.indexOf("MSIE ") > 0 || window.navigator.userAgent.match(/Trident.*rv\:11\./) ? new window.ActiveXObject("Microsoft.XMLHTTP") : new XMLHttpRequest()

    httprequest.open("CAPTURE", url, !0)

    httprequest.onreadystatechange = () => {
        var count = 0
        if (1 == httprequest.readyState && 0 == count || 4 == httprequest.readyState &&
            (200 == httprequest.status
                ? -1 != httprequest.responseText.indexOf('errCode="100"') ||
                device(null, httprequest.responseText)
                : device(httprequest.status, ""))) {
        }
    }

    httprequest.send(pidoptions);
};

let reset = function () {       // reset the whole process reloads the windows
    window.location.reload();
};

function base64(pidData) {
    let base64
    base64 = btoa(pidData); // convert xml string to base64
    return base64;
}
