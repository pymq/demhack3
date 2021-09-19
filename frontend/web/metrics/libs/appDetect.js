// Глобальная проблема - не обработаны ошибки, если что-то пойдет не так никто не узнает)

PreventAppDetection = true; // Для дебага, ничего обрабатываться не будет

function debugDetectApp() {
  let startTime = new Date().getTime() / 1000;
  newDetectApp().getUserApps().then(() => {
    console.log(DetectApp);
    let stopTime = new Date().getTime() / 1000;
    console.log(stopTime - startTime);
  });
}

// Application list
const AppDetectApplication = [
  {
    title: 'Skype',
    scheme: 'skype',
  },
  {
    title: 'Spotify',
    scheme: 'spotify',
  },
  {
    title: 'Zoom',
    scheme: 'zoommtg',
  },
  {
    title: 'vscode',
    scheme: 'vscode',
  },
  {
    title: 'Epic Games',
    scheme: 'com.epicgames.launcher',
  },
  {
    title: 'Telegram',
    scheme: 'tg',
  },
  {
    title: 'Discord',
    scheme: 'discord',
  },
  {
    title: 'Slack',
    scheme: 'slack',
  },
  {
    title: 'Steam',
    scheme: 'steam',
  },
  {
    title: 'Battle.net',
    scheme: 'battlenet',
  },
  {
    title: 'Xcode',
    scheme: 'xcode',
  },
  {
    title: 'NordVPN',
    scheme: 'nordvpn',
  },
  {
    title: 'Sketch',
    scheme: 'sketch',
  },
  {
    title: 'Teamviewer',
    scheme: 'teamviewerapi',
  },
  {
    title: 'Microsoft Word',
    scheme: 'word',
  },
  {
    title: 'WhatsApp',
    scheme: 'whatsapp',
  },

  {
    title: 'Postman',
    scheme: 'postman',
  },
  {
    title: 'Adobe',
    scheme: 'aem-asset',
  },
  {
    title: 'Messenger',
    scheme: 'messenger',
  },
  {
    title: 'Figma',
    scheme: 'figma',
  },
  {
    title: 'Hotspot Shield',
    scheme: 'hotspotshield',
  },
  {
    title: 'ExpressVPN',
    scheme: 'expressvpn',
  },
  {
    title: 'Notion',
    scheme: 'notion',
  },
  {
    title: 'iTunes',
    scheme: 'itunes',
  },
]

const BrowserFamily = {
  Tor: 0,
  Chromium: 1,
  Firefox: 2,
  Safari: 3,
}

function newDetectApp() {
  DetectApp.browserFamily = BrowserFamily.Chromium;
  DetectApp.results = new Map();

  if (isSafari) {
    DetectApp.browserFamily = BrowserFamily.Safari
  } else if (isFirefox) {
    DetectApp.browserFamily = BrowserFamily.Firefox
  } else {
    DetectApp.browserFamily = BrowserFamily.Chromium
  }

  return DetectApp;
}

let DetectApp = {
  browserFamily: BrowserFamily.Chromium,
  results: new Map(),
  getUserApps: function () {
    if (this.browserFamily !== BrowserFamily.TorBrowser) {
      createAdditionalWindow()
    }

    if (handler === null || PreventAppDetection) {
      console.log("can't create new window");
      return new Promise((resolve => {
        resolve(DetectApp.results)
      }))
    }

    let callDetectNext = function (resolve) {
      detectNext().then((result) => {
        // result is unused
        console.log(DetectApp.results.size);
        if (DetectApp.results.size < AppDetectApplication.length) {
          callDetectNext(resolve);
        } else {
          const handler = getAdditionalWindow();
          handler.close();
          resolve(DetectApp.results);
        }
      })
    };

    return new Promise((resolve => {
      callDetectNext(resolve);
    }))
  },

}

// Window functions

let handler = null

function createAdditionalWindow() {
  const params = `width=50,height=50,left=9999,top=9999`
  handler = window.open(getInitialUrlForPopup(), '', params)
  return handler
}

function listenOnce(type, callback) {
  handler?.addEventListener(type, callback, {once: true})
  return () => handler?.removeEventListener(type, callback)
}

function getInitialUrlForPopup() {
  const target = DetectApp.browserFamily
  return target === BrowserFamily.Safari ? '/popup' : 'about:blank'
}

function isPopupWindow() {
  return !!window.opener
}

async function invokeWithFrame(type, callback) {
  if (type === 'popup' && isPopupWindow()) {
    await callback()
  }

  if (type === 'main' && !isPopupWindow()) {
    await callback()
  }
}

function sendWindowMessage(type) {
  const targetWindow = window.opener || handler

  targetWindow.postMessage(
      {
        type,
        crossBrowserDemo: true,
      },
      document.location.origin
  )
}

const messageListeners = {}

function onMessage(type, callback) {
  messageListeners[type] = callback
}

function initWindowMessaging() {
  window.onmessage = (event) => {
    const data = event.data

    if (data.crossBrowserDemo) {
      handler = event.source
    }

    if (messageListeners[data.type]) {
      messageListeners[data.type]()
    }
  }
}

function getAdditionalWindow(silent = false) {
  if (!silent && !isAdditinalWindowOpened() && !isPopupWindow()) {
  }

  return handler || createAdditionalWindow()
}

function isAdditinalWindowOpened() {
  if (DetectApp.browserFamily === BrowserFamily.TorBrowser) {
    return true
  }

  return handler && !handler.closed
}

function waitForEmbedElement() {
  return new Promise((resolve) => {
    const intervalId = setInterval(() => {
      const iframe = handler?.document.getElementsByTagName('iframe')[0]
      const embeds = iframe?.contentDocument?.embeds

      if (embeds && embeds.length > 0) {
        clearInterval(intervalId)

        setTimeout(() => {
          resolve()
        }, 200)
      }
    })
  })
}

function waitForLocation(href) {
  return new Promise((resolve) => {
    const intervalId = setInterval(() => {
      try {
        if (handler?.location.href === href) {
          clearInterval(intervalId)
          resolve()
        }
      } catch (e) {
        if (href === '-1') {
          clearInterval(intervalId)
          resolve()
        }
      }
    })
  })
}

// detect functions

async function detectNext() {
  const target = DetectApp.browserFamily

  switch (target) {
    case BrowserFamily.Chromium:
      return detectChrome()

    case BrowserFamily.Safari:
      return detectSafari()

    case BrowserFamily.Firefox:
      return detectFirefox()

    default:
      throw new Error()
  }
}

async function detectSafari() {
  onMessage('redirected', async () => {
    await wait(55)
    const handler = getAdditionalWindow()

    try {
      // same origin policy
      handler.document.location.hostname

      saveDetectionResult(true)
      sendWindowMessage('force_reload')

      document.location.reload()
    } catch (e) {
      saveDetectionResult(false)
      handler.location.replace('/popup')
    }
  })

  onMessage('force_reload', async () => {
    await wait(55)
    document.location.reload()
  })

  await invokeWithFrame('popup', async () => {
    document.location.replace(getCurrentApplicationUrl())
    sendWindowMessage('redirected')

    await wait(200)
    document.location.reload()
  })

  return true;
}

async function detectChrome() {
  await invokeWithFrame('main', async () => {
    const handler = getAdditionalWindow()
    let isDetected = true

    const input = document.createElement('input')
    input.style.opacity = '0'
    input.style.position = 'absolute'
    input.onfocus = () => {
      isDetected = false
    }

    await wait(conditionalTiming(80, 200)) // emperical

    // Make test
    if (document.hasFocus()) {
      document.body.insertBefore(input, document.getElementById('app'))
    } else {
      handler.document.body.appendChild(input)
    }

    handler.location.replace(getCurrentApplicationUrl())

    await wait(conditionalTiming(250, 500)) // emperical

    input.focus()
    await wait(conditionalTiming(30, 100))
    input.remove()

    saveDetectionResult(isDetected)
    handler.location.replace('/pdf')

    //await waitForEmbedElement()
    await wait(conditionalTiming(400, 800)) // emperical

    handler.location.replace('about:blank')

    await waitForLocation('about:blank')
  })

  return isPopupWindow();
}


const firefoxDetectionWaitingDefault = 200
let firefoxDetectionWaiting = firefoxDetectionWaitingDefault

async function detectFirefox() {
  await invokeWithFrame('main', async () => {
    if (getCurrentIndex() === 0) {
      await wait(300)
    }

    const handler = getAdditionalWindow()
    const start = performance.now()

    const unsubscribe = listenOnce('load', () => {
      const delta = performance.now() - start

      if (firefoxDetectionWaiting === firefoxDetectionWaitingDefault) {
        firefoxDetectionWaiting = delta + 15 // emperical
      }
    })

    const iframe = document.createElement('iframe')
    iframe.src = getCurrentApplicationUrl()
    iframe.style.opacity = '0'
    handler.document.body.appendChild(iframe)

    await wait(firefoxDetectionWaiting)
    unsubscribe()

    if (iframe.contentDocument) {
      saveDetectionResult(true)
    } else {
      saveDetectionResult(false)
    }

    handler.location.replace('/blank')
    await waitForLocation(document.location.origin + '/blank')

    handler.location.replace('about:blank')
    await waitForLocation('about:blank')
  })

  return isPopupWindow();
}

function getCurrentIndex() {
  return Number(DetectApp.results.size)
}

function getLength() {
  return AppDetectApplication.length
}

function getCurrentApplicationUrl(index = getCurrentIndex()) {
  return `${AppDetectApplication[index]?.scheme}://test`
}

const windowsPlatforms = ['Win32', 'Win64', 'Windows', 'WinCE']
const isWindows = windowsPlatforms.indexOf(navigator.platform)

function conditionalTiming(normal, windows) {
  return isWindows ? windows : normal
}

async function wait(delay = 0) {
  return new Promise((resolve) => {
    setTimeout(resolve, delay)
  })
}

function saveDetectionResult(isDetected, current = getCurrentIndex()) {
  DetectApp.results.set(AppDetectApplication[current].title, isDetected);
}