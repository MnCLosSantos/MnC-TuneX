window.addEventListener('message', function(event) {
  if (event.data.action === 'showUI') {
    document.body.style.display = 'flex';
    showMainPage();
  } else if (event.data.action === 'hideUI') {
    document.body.style.display = 'none';
  }
});

function showMainPage() {
  document.getElementById('mainPage').style.display = 'flex';
  document.getElementById('settingsPage').style.display = 'none';
}

function showSettingsPage() {
  document.getElementById('mainPage').style.display = 'none';
  document.getElementById('settingsPage').style.display = 'flex';
}

document.getElementById('closeBtn').addEventListener('click', () => {
  fetch(`https://${GetParentResourceName()}/closeUI`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({}),
  }).then(() => {
    document.body.style.display = 'none';
  });
});

document.getElementById('exitFromSettingsBtn').addEventListener('click', () => {
  fetch(`https://${GetParentResourceName()}/closeUI`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({}),
  }).then(() => {
    document.body.style.display = 'none';
  });
});

document.getElementById('uploadBtn').addEventListener('click', () => {
  toggleButtons(false);
  fetch(`https://${GetParentResourceName()}/uploadTune`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({}),
  }).then(() => {
    toggleButtons(true);
  });
});

document.getElementById('disconnectBtn').addEventListener('click', () => {
  toggleButtons(false);
  fetch(`https://${GetParentResourceName()}/disconnectOBD`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({}),
  }).then(() => {
    toggleButtons(true);
  });
});

document.getElementById('settingsBtn').addEventListener('click', () => {
  showSettingsPage();
});

document.getElementById('backBtn').addEventListener('click', () => {
  showMainPage();
});

document.getElementById('customSettingsBtn').addEventListener('click', () => {
  toggleButtons(false);
  fetch(`https://${GetParentResourceName()}/decryptFiles`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({}),
  }).then(() => {
    toggleButtons(true);
  });
});

document.getElementById('disconnectEncryptedBtn').addEventListener('click', () => {
  toggleButtons(false);
  fetch(`https://${GetParentResourceName()}/disconnectDrive`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({}),
  }).then(() => {
    toggleButtons(true);
  });
});

document.addEventListener('keydown', function(event) {
  if (event.key === 'Escape') {
    fetch(`https://${GetParentResourceName()}/escape`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({})
    });
  }
});

function toggleButtons(enable) {
  [
    'uploadBtn',
    'disconnectBtn',
    'closeBtn',
    'settingsBtn',
    'backBtn',
    'exitFromSettingsBtn',
    'customSettingsBtn',
    'disconnectEncryptedBtn'
  ].forEach(id => {
    const btn = document.getElementById(id);
    if (btn) btn.disabled = !enable;
  });
}
