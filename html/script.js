const clickSound = document.getElementById('clickSound');

function playClick() {
  clickSound.currentTime = 0;
  clickSound.play();
}

window.addEventListener('message', function (event) {
  if (event.data.action === 'showUI') {
    document.body.style.display = 'flex';
  } else if (event.data.action === 'hideUI') {
    document.body.style.display = 'none';
  }
});

document.getElementById('uploadBtn').addEventListener('click', function () {
  playClick();
  fetch(`https://${GetParentResourceName()}/uploadTune`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ apply: true }),
  });
});

document.getElementById('closeBtn').addEventListener('click', function () {
  playClick();
  document.body.style.display = 'none';
  fetch(`https://${GetParentResourceName()}/closeUI`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    }
  });
});

document.addEventListener('keydown', function (e) {
  if (e.key === "Escape") {
    document.body.style.display = 'none';
    fetch(`https://${GetParentResourceName()}/closeUI`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      }
    });
  }
});
