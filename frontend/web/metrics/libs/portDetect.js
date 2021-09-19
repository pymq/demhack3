Ports = [
  22,80,443,3306,5432,8000,8080
]

function debugGetOpenPorts() {
  let startTime = new Date().getTime() / 1000;
  getOpenPorts().then(res=>{
    console.log(res);
    let stopTime = new Date().getTime() / 1000;
    console.log(stopTime - startTime);
  });
}

function getOpenPorts() {
  let scannedPortsResult = {};
  const portsInOnePromises = 5;
  let doPortsScan = function (resolve) {
    let startIndex = Object.keys(scannedPortsResult).length;
    let promises = [];
    for (let i = startIndex; i < startIndex + portsInOnePromises; i++) {
      if (i >= Ports.length) {
        break;
      }
      promises.push(portIsOpen('127.0.0.1', Ports[i]));
    }
    if (promises.length > 0) {
      Promise.all(promises).then(values => {
        values.forEach(function (portInfo) {
          scannedPortsResult[portInfo[0]] = portInfo[1];
        })
        if (Object.keys(scannedPortsResult).length < Ports.length) {
          doPortsScan(resolve);
        } else {
          resolve(scannedPortsResult);
        }
      });
    } else {
      resolve(scannedPortsResult);
    }
  }

  return new Promise(resolve => {
    doPortsScan(resolve);
  })
}


var portIsOpen = function(hostToScan, portToScan, N = 15) {
  return new Promise((resolve, reject) => {
    var portIsOpen = 'unknown';

    var timePortImage = function(port) {
      return new Promise((resolve, reject) => {
        var t0 = performance.now()
        // a random appendix to the URL to prevent caching
        var random = Math.random().toString().replace('0.', '').slice(0, 7)
        var img = new Image;

        img.onerror = function() {
          var elapsed = (performance.now() - t0)
          // close the socket before we return
          resolve(parseFloat(elapsed.toFixed(3)))
        }

        img.src = "http://" + hostToScan + ":" + port + '/' + random + '.png'
      })
    }

    const portClosed = 37857; // let's hope it's closed :D

    (async () => {
      var timingsOpen = [];
      var timingsClosed = [];
      for (var i = 0; i < N; i++) {
        timingsOpen.push(await timePortImage(portToScan))
        timingsClosed.push(await timePortImage(portClosed))
      }

      var sum = (arr) => arr.reduce((a, b) => a + b);
      var sumOpen = sum(timingsOpen);
      var sumClosed = sum(timingsClosed);
      var test1 = sumOpen >= (sumClosed * 1.3);
      var test2 = false;

      var m = 0;
      for (var i = 0; i <= N; i++) {
        if (timingsOpen[i] > timingsClosed[i]) {
          m++;
        }
      }
      // 80% of timings of open port must be larger than closed ports
      test2 = (m >= Math.floor(0.8 * N));

      portIsOpen = test1 && test2;
      resolve([portToScan, portIsOpen, m, sumOpen, sumClosed]);
    })();
  });
}