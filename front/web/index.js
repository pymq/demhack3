function getMetrics() {
  return (async () => {
    return await Promise.all([getBrowserFingerPrintLibDataPromise()]).then(values => {
      console.log(values[0]);
      let Metrics = {};
      let fingerprintJS = values[0].components;
      Object.keys(fingerprintJS).forEach(function (key) {
        Metrics[key] = fingerprintJS[key].value;
      });
      return Metrics
    })
  })()
}

function getBrowserFingerPrintLibDataPromise() {
  console.log('fingerprint js start');

  const fpPromise = FingerprintJS.load()

  return (async () => {
    console.log('fingerprint js');
    const fp = await fpPromise
    return await fp.get()
  })()
}

function fetchMetrics(name, metricsObject) {
  Metrics.name = metricsObject;
}