const ConsoleSilentMode = true; // убрать комменты

function getMetrics() {
  return (async () => {
    return await Promise.all([getFPJSLibDataPromise()]).then(values => {
      let Metrics = {};
      let fingerprintJS = values[0].components;
      Object.keys(fingerprintJS).forEach(function (key) {
        Metrics[key] = fingerprintJS[key].value;
      });
      return Metrics;
    })
  })()
}

function getFPJSLibDataPromise() {
  doConsoleLog('fingerprint js start');

  const fpPromise = FingerprintJS.load()

  return (async () => {
    doConsoleLog('fingerprint js');
    const fp = await fpPromise;
    return await fp.get();
  })()
}

function doConsoleLog(logMessage) {
  if (ConsoleSilentMode) return;
  console.log(logMessage);
}

// Debug

function consolePrintGetMetrics() {
  getMetrics().then(value => {
    console.log(value);
  });
}

function consolePrintJSONGetMetrics() {
  getMetrics().then(value => {
    console.log(JSON.stringify(value));
  });
}