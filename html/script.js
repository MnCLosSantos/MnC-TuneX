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
  document.getElementById('autoDrivePage').style.display = 'none';
  document.getElementById('driftModePage').style.display = 'none';
}

function showSettingsPage() {
  document.getElementById('mainPage').style.display = 'none';
  document.getElementById('settingsPage').style.display = 'flex';
  document.getElementById('autoDrivePage').style.display = 'none';
  document.getElementById('driftModePage').style.display = 'none';
}

function showAutoDrivePage() {
  document.getElementById('mainPage').style.display = 'none';
  document.getElementById('settingsPage').style.display = 'none';
  document.getElementById('autoDrivePage').style.display = 'flex';
  document.getElementById('driftModePage').style.display = 'none';
}

function showDriftModePage() {
  document.getElementById('mainPage').style.display = 'none';
  document.getElementById('settingsPage').style.display = 'none';
  document.getElementById('autoDrivePage').style.display = 'none';
  document.getElementById('driftModePage').style.display = 'flex';
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

document.getElementById('exitFromDriftPageBtn')?.addEventListener('click', () => {
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

document.getElementById('settingsBtn').addEventListener('click', showSettingsPage);
document.getElementById('backBtn').addEventListener('click', showMainPage);
document.getElementById('nextToAutoDriveBtn').addEventListener('click', showAutoDrivePage);
document.getElementById('backFromAutoDriveBtn').addEventListener('click', showSettingsPage);
document.getElementById('nextToDriftPageBtn').addEventListener('click', showDriftModePage);
document.getElementById('backFromDriftPageBtn').addEventListener('click', showAutoDrivePage);

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

document.getElementById("startAutopilotBtn")?.addEventListener("click", () => {
  fetch(`https://${GetParentResourceName()}/tuner:checkAutopilotStart`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: "{}"
  });
});

document.getElementById("stopAutopilotBtn")?.addEventListener("click", () => {
  fetch(`https://${GetParentResourceName()}/tuner:checkAutopilotStop`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: "{}"
  });
});

document.getElementById("toggleDriftModeBtn")?.addEventListener("click", () => {
  fetch(`https://${GetParentResourceName()}/toggleDriftMode`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: "{}"
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

document.getElementById("removeAutoDriveKitBtn")?.addEventListener("click", () => {
  fetch(`https://${GetParentResourceName()}/removeAutoDriveKit`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: "{}"
  });
});

document.getElementById("removeDriftKitBtn")?.addEventListener("click", () => {
  fetch(`https://${GetParentResourceName()}/removeDriftKit`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: "{}"
  });
});

// Show Vehicle Assist Settings page
document.getElementById('vehicleAssistBtn').addEventListener('click', () => {
  document.getElementById('mainPage').style.display = 'none';
  document.getElementById('vehicleAssistPage').style.display = 'block';
});

// Back button on Vehicle Assist page
document.getElementById('backFromVehicleAssistBtn').addEventListener('click', () => {
  document.getElementById('vehicleAssistPage').style.display = 'none';
  document.getElementById('mainPage').style.display = 'block';
});

document.getElementById('exitFromVehicleAssistBtn').addEventListener('click', () => {
  fetch(`https://${GetParentResourceName()}/closeUI`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({}),
  }).then(() => {
    document.body.style.display = 'none';
  });
});


// Track TSC state: false = off, true = on
let tscEnabled = true;

// Reference the TSC button and icon span inside it
const tscBtn = document.getElementById('tscBtn');
const tscIcon = tscBtn.querySelector('.btn-icon');

tscBtn.addEventListener('click', () => {
  // Toggle the state
  tscEnabled = !tscEnabled;

  // Update button color and icon
  if (tscEnabled) {
    tscBtn.style.backgroundColor = '#F9D342'; // yellow
    tscIcon.textContent = '🟢'; // green circle icon
  } else {
    tscBtn.style.backgroundColor = '#ff4c4c'; // red
    tscIcon.textContent = '🔴'; // red circle icon
  }

  // Send POST request to resource with new TSC state
  fetch(`https://${GetParentResourceName()}/toggleTSC`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ enabled: tscEnabled }),
  });
});

// Track ESP state: false = off, true = on
let espEnabled = true;

// Reference the ESP button and icon span inside it
const espBtn = document.getElementById('espBtn');
const espIcon = espBtn.querySelector('.btn-icon');

espBtn.addEventListener('click', () => {
  // Toggle the state
  espEnabled = !espEnabled;

  // Update button color and icon
  if (espEnabled) {
    espBtn.style.backgroundColor = '#F9D342'; // yellow
    espIcon.textContent = '🟢'; // green circle icon
  } else {
    espBtn.style.backgroundColor = '#ff4c4c'; // red
    espIcon.textContent = '🔴'; // red circle icon
  }

  // Send POST request to resource with new ESP state
  fetch(`https://${GetParentResourceName()}/toggleESP`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ enabled: espEnabled }),
  });
});

let absEnabled = true;

const absBtn = document.getElementById('absBtn');
const absIcon = absBtn.querySelector('.btn-icon');

absBtn.addEventListener('click', () => {
  absEnabled = !absEnabled;

  if (absEnabled) {
    absBtn.style.backgroundColor = '#F9D342'; // yellow
    absIcon.textContent = '🟢'; // green circle
  } else {
    absBtn.style.backgroundColor = '#ff4c4c'; // red
    absIcon.textContent = '🔴'; // red circle
  }

  fetch(`https://${GetParentResourceName()}/toggleABS`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ enabled: absEnabled }),
  });
});


function toggleButtons(enable) {
  [
    'uploadBtn',
    'disconnectBtn',
    'closeBtn',
    'settingsBtn',
    'backBtn',
    'customSettingsBtn',
    'disconnectEncryptedBtn',
    'nextToAutoDriveBtn',
    'nextToDriftPageBtn',
    'exitFromDriftPageBtn',
    'exitFromAutoDriveBtn',
    'backFromAutoDriveBtn',
    'backFromDriftPageBtn',
    'startAutopilotBtn',
    'stopAutopilotBtn',
	'removeAutoDriveKitBtn',
    'toggleDriftModeBtn',
    'removeDriftKitBtn'
  ].forEach(id => {
    const btn = document.getElementById(id);
    if (btn) btn.disabled = !enable;
  });
}
