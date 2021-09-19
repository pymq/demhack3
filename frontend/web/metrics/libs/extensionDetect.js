const Extensions = {
1: {
  id : 'cfhdojbkjhnklbpkdaibdccddilifddb',
  title: 'ADBlockPlus',
  sourceFile: 'options.html'
}
}

function getExtensions() {
  fetch('chrome-extension://' + Extensions[1].id + '/' + Extensions[1].sourceFile).then(
      (response) => {
        if (response.ok) {
          console.log('success');
        }
      },
      () => {}
  );
}